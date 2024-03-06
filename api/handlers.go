package main

import (
	"errors"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

type Coordinates struct {
	Lat  float64 `json:"lat"`
	Long float64 `json:"long"`
}

type Announcement struct {
	Id           string      `json:"id"`
	UserID       string      `json:"userID"`
	Category     string      `json:"category"`
	Description  string      `json:"description"`
	Localization Coordinates `json:"localization"`
}

var annoucemnts []Announcement = []Announcement{
	{"adgadg", "1s5d2", "carpenter", "looking for a job", Coordinates{-1.554, 2.546}},
	{"2f1sfa", "fas3f", "painter", "looking for a wall to paint", Coordinates{-3.454, 2.126}},
}

// for user check that api is running 
func handleReadiness(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, struct{}{})
}

func handleError(c *gin.Context) {
	c.IndentedJSON(http.StatusInternalServerError, "Somthing went wrong")
}

func handleGetAnnouncemnts(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, annoucemnts)
}

func getAnnouncementByID(userID string) (*Announcement, error) {
	for i, annoucemnt := range annoucemnts {
		if annoucemnt.UserID == userID {
			return &annoucemnts[i], nil
		}
	}
	return nil, errors.New("announcement not found")
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

	annoucemnts = append(annoucemnts, newAnnouncement)
	c.IndentedJSON(http.StatusCreated, newAnnouncement)
}

func handleDeleteAnnouncement(c *gin.Context) {
	id := c.Param("id")
	announcement, err := getAnnouncementByID(id)
	if err != nil {
		log.Printf("there is no announcement with userID %v", err)
		return
	}

	for i, announ := range annoucemnts {
		if announcement.UserID == announ.UserID {
			annoucemnts = append(annoucemnts[:i], annoucemnts[i+1:]...)
			break
		}
	}

	c.IndentedJSON(http.StatusOK, gin.H{"message": "Announcement deleted successfully"})
}

func handleUpdateAnnouncemnt(c *gin.Context) {
	id := c.Param("id")
	announcement, err := getAnnouncementByID(id)
	if err != nil {
		log.Printf("there is no announcement with userID %v", err)
		return
	}

	var newAnnouncement Announcement

	if err := c.BindJSON(&newAnnouncement); err != nil {
		// logging
		return
	}

	for i, announ := range annoucemnts {
		if announcement.UserID == announ.UserID {
			annoucemnts[i] = newAnnouncement
			break
		}
	}

	c.IndentedJSON(http.StatusOK, gin.H{"message": "Announcement updated successfully"})
}
