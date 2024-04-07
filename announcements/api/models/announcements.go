package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Coordinates struct {
	Lat  float64 `json:"lat" bson:"lat"`
	Long float64 `json:"long" bson:"long"`
}

type Announcement struct {
	Id          primitive.ObjectID `bson:"_id"`
	UserID      string             `json:"userID" bson:"userID"`
	Category    string             `json:"category" bson:"category"`
	Description string             `json:"description" bson:"description"`
	Location    Coordinates        `json:"location" bson:"location"`
}
