package main

import (
	//"errors"

	"log"
	"net/http"
	"strconv"

	. "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/models"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// for user check that api is running
func handleReadiness(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, struct{}{})
}

func handleGetAnnouncemnts(c *gin.Context) {
	radiusQuery := c.Query("radius")
	latQuery := c.Query("lat")
	longQuery := c.Query("long")

	var announcements []Announcement
	var err error

	if radiusQuery != "" && latQuery != "" && longQuery != "" {
		radius, err := strconv.ParseFloat(radiusQuery, 64)
		if err != nil {
			c.IndentedJSON(
				http.StatusBadRequest,
				APIError{
					StatusCode: http.StatusBadRequest,
					Message:    "couldn't parse radius",
				})
			return
		}

		lat, err := strconv.ParseFloat(latQuery, 64)
		if err != nil {
			c.IndentedJSON(
				http.StatusBadRequest,
				APIError{
					StatusCode: http.StatusBadRequest,
					Message:    "couldn't parse latitute",
				})
			return
		}
		long, err := strconv.ParseFloat(longQuery, 64)
		if err != nil {
			c.IndentedJSON(
				http.StatusBadRequest,
				APIError{
					StatusCode: http.StatusBadRequest,
					Message:    "couldn't parse longitute",
				})
			return
		}

		announcements, err = AnnouncementDB.GetAnnouncementsByRadius(
			Coordinates{Lat: lat, Long: long},
			radius,
		)
	} else {
		if radiusQuery == "" && latQuery != "" && longQuery != "" {
			announcements, err = AnnouncementDB.GetAllAnnouncements()
		} else {
			c.IndentedJSON(
				http.StatusBadRequest,
				APIError{
					StatusCode: http.StatusBadRequest,
					Message:    "must have all or none of the following query parameters: radius, lat, long",
				})
		}

	}

	if err != nil {
		c.IndentedJSON(
			http.StatusServiceUnavailable,
			APIError{
				StatusCode: http.StatusServiceUnavailable,
				Message:    "couldn't get announcements",
			})
		log.Print(err)
		return
	}

	c.IndentedJSON(http.StatusOK, announcements)
}

func getAnnouncementByID(userID string) (*Announcement, error) {
	objUserID, err := primitive.ObjectIDFromHex(userID)
	if err != nil || len(userID) != 24 {
		return nil, err
	}

	announcement, err := AnnouncementDB.GetAnnouncement(objUserID)
	if err != nil {
		return nil, err
	}

	return &announcement, nil
}

func handleGetAnnouncementsByID(c *gin.Context) {
	id := c.Param("id")
	announcement, err := getAnnouncementByID(id)

	if err != nil {
		c.IndentedJSON(
			http.StatusNotFound,
			APIError{
				StatusCode: http.StatusNotFound,
				Message:    "invalid id for announcement",
			})
		return
	}
	c.IndentedJSON(http.StatusOK, announcement)
}

func handleCreateAnnouncement(c *gin.Context) {
	var newAnnouncement Announcement

	if err := c.BindJSON(&newAnnouncement); err != nil {
		c.IndentedJSON(
			http.StatusBadRequest,
			APIError{
				StatusCode: http.StatusBadRequest,
				Message:    "invalid JSON announcement format in body",
			})
		return
	}

	createdAnnouncement, err := AnnouncementDB.CreateAnnouncement(newAnnouncement)

	if err != nil {
		c.IndentedJSON(
			http.StatusInternalServerError,
			APIError{
				StatusCode: http.StatusInternalServerError,
				Message:    "couldnt create announcement",
			})
		log.Print(err)
		return
	}

	c.IndentedJSON(http.StatusCreated, createdAnnouncement)
}

func handleDeleteAnnouncement(c *gin.Context) {
	id := c.Param("id")

	objUserID, err := primitive.ObjectIDFromHex(id)
	if err != nil || len(id) != 24 {
		c.IndentedJSON(
			http.StatusNotFound,
			APIError{
				StatusCode: http.StatusNotFound,
				Message:    "invalid id for announcement",
			})
		return
	}

	if err := AnnouncementDB.DeleteAnnouncement(objUserID); err != nil {
		c.IndentedJSON(
			http.StatusNotFound,
			APIError{
				StatusCode: http.StatusNotFound,
				Message:    "announcement not found",
			})
		return
	}

	c.IndentedJSON(
		http.StatusOK,
		APIMessage{
			StatusCode: http.StatusOK,
			Message:    "announcement deleted successfully",
		})
}

func handleUpdateAnnouncemnt(c *gin.Context) {
	id := c.Param("id")

	var newAnnouncement Announcement

	if err := c.BindJSON(&newAnnouncement); err != nil {
		c.IndentedJSON(
			http.StatusBadRequest,
			APIError{
				StatusCode: http.StatusBadRequest,
				Message:    "invalid JSON announcement format in body",
			})
		log.Print(err)
		return
	}

	objUserID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.IndentedJSON(
			http.StatusNotFound,
			APIError{
				StatusCode: http.StatusNotFound,
				Message:    "invalid id for announcement",
			})
		return

	}

	updatedAnnouncement, err := AnnouncementDB.UpdateAnnouncement(objUserID, newAnnouncement)
	if err != nil {
		c.IndentedJSON(
			http.StatusInternalServerError,
			APIError{
				StatusCode: http.StatusInternalServerError,
				Message:    "couldn't update announcement",
			})
		log.Print(err)
		return
	}

	c.IndentedJSON(http.StatusOK, updatedAnnouncement)
}
