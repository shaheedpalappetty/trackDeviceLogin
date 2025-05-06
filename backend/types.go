package main

type LoginRequest struct {
	Username   string `json:"username"`
	Password   string `json:"password"`
	DeviceID   string `json:"device_id"`
	IsLoggedIn bool   `json:"is_logged_in" default:"false"`
}
