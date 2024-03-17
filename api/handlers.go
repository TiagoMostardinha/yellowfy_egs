package main

import (
	"log"
	"net/http"
	"strconv"

	. "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/models"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// for user check that api is running
// HealthCheck		godoc
// @Summary			Health check
// @Description		Checks if the API is running.
// @Produce			applcation/json
// @Tags			Announcements
// @Success			200
// @Router			/healthz [get]
func handleReadiness(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, struct{}{})
}

// GetAnnouncements	godoc
// @Summary			Get all announcements
// @Description		Get all announcements from the database or filter by location and radius
// @Param			radius	query	float64	false	"radius in meters"
// @Param			lat		query	float64	false	"latitude"
// @Param			long	query	float64	false	"longitude"
// @Produce			applcation/json
// @Tags			Announcements
// @Success			200 {array} Announcement
// @Failure			400 {object} APIError
// @Failure			503 {object} APIError
// @Router			/ [get]
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
		if radiusQuery == "" && latQuery == "" && longQuery == "" {
			announcements, err = AnnouncementDB.GetAllAnnouncements()
		} else {
			c.IndentedJSON(
				http.StatusBadRequest,
				APIError{
					StatusCode: http.StatusBadRequest,
					Message:    "must have all or none of the following query parameters: radius, lat, long",
				})
			return
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

// GetAnnouncementByID	godoc
// @Summary			Get announcement by ID
// @Description		Get announcement by ID from the database
// @Param			id	path	string	true	"announcement ID"
// @Produce			applcation/json
// @Tags			Announcements
// @Success			200 {object} Announcement
// @Failure			404 {object} APIError
// @Router			/{id} [get]
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

// CreateAnnouncement	godoc
// @Summary			Create a new announcement
// @Description		Create a new announcement in the database
// @Param			announcement	body	Announcement	true	"announcement object"
// @Produce			applcation/json
// @Tags			Announcements
// @Success			200 {object} Announcement
// @Failure			400 {object} APIError
// @Failure			500 {object} APIError
// @Router			/ [post]
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

// DeleteAnnouncement	godoc
// @Summary			Delete announcement by ID
// @Description		Delete announcement by ID from the database
// @Param			id	path	string	true	"announcement ID"
// @Produce			applcation/json
// @Tags			Announcements
// @Success			200 {object} APIMessage
// @Failure			404 {object} APIError
// @Router			/{id} [delete]
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

// UpdateAnnouncemnt	godoc
// @Summary			Update announcement by ID
// @Description		Update announcement by ID from the database
// @Param			id	path	string	true	"announcement ID"
// @Param			announcement	body	Announcement	true	"announcement object"
// @Produce			applcation/json
// @Tags			Announcements
// @Success			200 {object} Announcement
// @Failure			404 {object} APIError
// @Failure			500 {object} APIError
// @Router			/{id} [put]
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
