package gofluttertodolist

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"strconv"

	"time"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type Model struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	CreatedAt time.Time      `json:"createdAt"`
	UpdatedAt time.Time      `json:"updatedAt"`
	DeletedAt gorm.DeletedAt `json:"deletedAt" gorm:"index"`
}

type Post struct {
	Model
	Name    string `json:"name" binding:"required"`
	Content string `json:"content" binding:"required"`
}

func setupRouter() *gin.Engine {
	db, err := gorm.Open(sqlite.Open("data.db"), &gorm.Config{})

	if err != nil {
		panic("Database connection error.")
	}

	db.AutoMigrate(&Post{})

	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "pong"})
	})

	r.GET("/posts", func(c *gin.Context) {
		var posts []Post

		db.Find(&posts)

		c.JSON(http.StatusOK, posts)
	})

	r.GET("/post/:id", func(c *gin.Context) {
		var id, err = strconv.ParseUint(c.Params.ByName("id"), 10, 1)

		if err != nil {
			c.AbortWithError(http.StatusBadRequest, err)

			return
		}

		var post Post

		var value = db.First(&post, id)

		c.JSON(http.StatusOK, value)
	})

	r.POST("/post", func(c *gin.Context) {

		var post = Post{}

		if err := c.BindJSON(&post); err != nil {
			c.AbortWithError(http.StatusBadRequest, err)

			return
		}

		db.Create(&Post{Name: post.Name, Content: post.Content})

		c.JSON(http.StatusCreated, gin.H{"message": "Post created."})
	})

	return r
}

func main() {
	r := setupRouter()

	r.Run(":8080")
}
