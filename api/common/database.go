package common

import (
	"context"
	"encoding/json"
	"errors"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Database struct {
	Client     *mongo.Client
	Collection *mongo.Collection
}

func (db Database) connect(dbURI string) error {
	client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(dbURI))
	if err != nil {
		return errors.New("couln't connect to database")
	}
	db.Client = client
	db.Collection = db.Client.Database("announcements").Collection("announcements")
	return nil
}

func (db Database) ping() error {
	err := db.Client.Ping(context.TODO(), nil)
	if err != nil {
		return errors.New("coudnt ping to database")
	}
	return nil
}

func (db Database) close() error {
	if err := db.Client.Disconnect(context.TODO()); err != nil {
		return err
	}
	return nil
}

func (db Database) getAllAnnouncemnts() []Announcement{
	var announcements []bson.M

	documents, err := db.Collection.Find(context.TODO(), bson.M{})
	if err != nil{
		return
	}

}
