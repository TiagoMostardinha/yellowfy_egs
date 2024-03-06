package common

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