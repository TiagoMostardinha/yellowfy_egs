package common

import (
	"context"
	"errors"
	"math"

	. "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Database struct {
	Client *mongo.Client
}

func (db *Database) Connect(dbURI string) error {
	client, err := mongo.Connect(
		context.TODO(),
		options.Client().ApplyURI(dbURI),
	)

	if err != nil {
		return errors.New("error connecting to database")
	}

	db.Client = client
	return nil
}

func (db *Database) Disconnect() error {
	err := db.Client.Disconnect(context.Background())
	if err != nil {
		return errors.New("error disconnecting from database")
	}
	return nil
}

func (db *Database) Ping() error {
	err := db.Client.Ping(context.Background(), nil)
	if err != nil {
		return errors.New("database not found")
	}
	return nil
}

func (db *Database) collection() *mongo.Collection {
	return db.Client.Database("announcements").Collection("announcements")
}

func (db *Database) GetAllAnnouncements() ([]Announcement, error) {
	err := db.Ping()
	if err != nil {
		return nil, err
	}

	collection := db.collection()

	cursor, err := collection.Find(context.TODO(), bson.D{{}})

	if err != nil {
		return nil, errors.New("couldn't fetch documents")
	}

	var announcements []Announcement

	if err = cursor.All(context.TODO(), &announcements); err != nil {
		return nil, errors.New("couldnt go throught the items in the collection")
	}

	return announcements, nil
}

func geoDistance(center, point Coordinates) float64 {
	centerLatRad := math.Pi * center.Lat / 180   // Convert latitude to radians
	centerLongRad := math.Pi * center.Long / 180 // Convert longitude to radians
	pointLatRad := math.Pi * point.Lat / 180     // Convert latitude to radians
	pointLongRad := math.Pi * point.Long / 180   // Convert longitude to radians

	distance := math.Acos(
		math.Sin(centerLatRad)*math.Sin(pointLatRad) +
			math.Cos(centerLatRad)*math.Cos(pointLatRad)*
				math.Cos(centerLongRad-pointLongRad),
	)

	return distance * 6371
}

func (db *Database) GetAnnouncementsByRadius(center Coordinates, radius float64) ([]Announcement, error) {
	announcements, err := db.GetAllAnnouncements()
	if err != nil {
		return nil, err
	}

	var announcementsInRadius []Announcement
	for _, announcement := range announcements {
		if geoDistance(center, announcement.Location) <= radius {
			announcementsInRadius = append(announcementsInRadius, announcement)
		}
	}
	return announcementsInRadius, nil
}

func (db *Database) GetAnnouncement(id primitive.ObjectID) (Announcement, error) {
	err := db.Ping()
	if err != nil {
		return Announcement{}, err
	}

	collection := db.collection()

	var announcement Announcement
	err = collection.FindOne(
		context.TODO(),
		bson.D{{Key: "_id", Value: id}},
	).Decode(&announcement)
	if err != nil {
		return Announcement{}, errors.New("couldn't find document in the database")
	}

	return announcement, nil
}

func (db *Database) CreateAnnouncement(newAnnouncement Announcement) (*Announcement, error) {
	err := db.Ping()
	if err != nil {
		return nil, err
	}

	collection := db.collection()

	newAnnouncement.Id = primitive.NewObjectID()

	_, err = collection.InsertOne(context.TODO(), newAnnouncement)
	if err != nil {
		return nil, errors.New("couldn't insert document to the database")
	}

	return &newAnnouncement, nil
}

func (db *Database) DeleteAnnouncement(id primitive.ObjectID) error {
	err := db.Ping()
	if err != nil {
		return err
	}

	collection := db.collection()

	_, err = collection.DeleteMany(
		context.TODO(),
		bson.D{{Key: "_id", Value: id}},
	)
	if err != nil {
		return errors.New("couldn't delete document from the database")
	}

	return nil
}

func (db *Database) UpdateAnnouncement(id primitive.ObjectID, updateAnnouncement Announcement) (*Announcement, error) {
	err := db.Ping()
	if err != nil {
		return nil, err
	}

	collection := db.collection()

	_, err = collection.UpdateOne(
		context.TODO(),
		bson.D{{Key: "_id", Value: id}},
		bson.D{{Key: "$set", Value: updateAnnouncement}},
	)

	if err != nil {
		return nil, errors.New("couldn't update the document from the database")
	}

	updated, err := db.GetAnnouncement(id)
	if err != nil {
		return nil, err
	}

	return &updated, nil
}
