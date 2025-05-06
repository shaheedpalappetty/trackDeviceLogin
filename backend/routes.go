package main

import (
	"github.com/gin-gonic/gin"
)

func authenticationRouter(router *gin.Engine) {
	r := router.Group("/auth")
	{
		r.POST("/login", loginHandler)
		r.POST("/logout", logoutHandler)
		r.GET("/checkloggedin/:deviceId", checkLoggedInHandler)
	}
}
