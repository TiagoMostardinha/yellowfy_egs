package main

import (
	//"errors"
	"log"
	"net/http"

	. "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/models"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// for user check that api is running
func handleReadiness(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, struct{}{})
}

func handleError(c *gin.Context) {
	c.IndentedJSON(http.StatusInternalServerError, "Somthing went wrong")
}

func handleGetAnnouncemnts(c *gin.Context) {
	announcements, err := AnnouncementDB.GetAllAnnouncements()
	if err != nil {
		log.Printf("couldnt fetch announcements")
		return
	}

	c.IndentedJSON(http.StatusOK, announcements)
}

func getAnnouncementByID(userID string) (*Announcement, error) {
	objUserID, err := primitive.ObjectIDFromHex(userID)
	if err != nil {
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
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "announcement not found"})
		return
	}
	c.IndentedJSON(http.StatusOK, announcement)
}

func handleCreateAnnouncement(c *gin.Context) {
	var newAnnouncement Announcement

	if err := c.BindJSON(&newAnnouncement); err != nil {
		return
	}

	createdAnnouncement, err := AnnouncementDB.CreateAnnouncement(newAnnouncement)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, "couldnt create announcement")
		return
	}

	c.IndentedJSON(http.StatusCreated, createdAnnouncement)
}

func handleDeleteAnnouncement(c *gin.Context) {
	id := c.Param("id")

	objUserID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "announcement not found"})
		return
	}

	if err := AnnouncementDB.DeleteAnnouncement(objUserID); err != nil {
		c.IndentedJSON(http.StatusInternalServerError, "couldnt delete announcement")
		return
	}

	c.IndentedJSON(http.StatusOK, gin.H{"message": "Announcement deleted successfully"})
}

func handleUpdateAnnouncemnt(c *gin.Context) {
	id := c.Param("id")

	var newAnnouncement Announcement

	if err := c.BindJSON(&newAnnouncement); err != nil {
		// logging
		return
	}

	objUserID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "announcement not found"})
		return

	}

	updatedAnnouncement, err := AnnouncementDB.UpdateAnnouncement(objUserID, newAnnouncement)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, "couldnt update announcement")
		return
	}

	c.IndentedJSON(http.StatusOK, updatedAnnouncement)
}
