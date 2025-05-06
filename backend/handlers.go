package main

import (
	gin "github.com/gin-gonic/gin"
)

var Users = []LoginRequest{{Username: "admin", Password: "admin", DeviceID: "1234567890", IsLoggedIn: false}, {Username: "admin1", Password: "admin1", DeviceID: "1234567892", IsLoggedIn: false}}

func loginHandler(c *gin.Context) {
	var req LoginRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}
	var found bool
	for i := range Users {
		if Users[i].Username == req.Username && Users[i].Password == req.Password {
			Users[i].IsLoggedIn = true
			found = true
			break
		}
	}

	if !found {
		c.JSON(401, gin.H{"error": "Invalid username or password"})
		return
	}

	c.JSON(200, gin.H{
		"message": "Login successful",
	})
}

func logoutHandler(c *gin.Context) {
	var req struct {
		DeviceID string `json:"deviceId"`
	}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	var found bool
	for i := range Users {
		if Users[i].DeviceID == req.DeviceID {
			Users[i].IsLoggedIn = false
			found = true
			break
		}
	}

	if !found {
		c.JSON(404, gin.H{"error": "Device not found"})
		return
	}

	c.JSON(200, gin.H{
		"message": "Logout successful",
	})
}

func checkLoggedInHandler(c *gin.Context) {

	device_id := c.Param("deviceId")

	var found bool
	var userFound LoginRequest
	for _, user := range Users {
		if user.DeviceID == device_id {
			userFound = user
			found = true
			break
		}
	}

	if !found {
		c.JSON(404, gin.H{"error": "Device not found"})
		return
	}

	c.JSON(200, gin.H{
		"loggedIn": userFound.IsLoggedIn,
	})
}
