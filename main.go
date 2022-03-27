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

type Todo struct {
	Model
	Title   string `json:"title" binding:"required"`
	Content string `json:"content" binding:"required"`
}

func setupRouter() *gin.Engine {
	db, err := gorm.Open(sqlite.Open("data.db"), &gorm.Config{})

	if err != nil {
		panic("Database connection error.")
	}

	db.AutoMigrate(&Todo{})

	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "pong"})
	})

	r.GET("/todos", func(c *gin.Context) {
		var todos []Todo

		db.Find(&todos)

		c.JSON(http.StatusOK, todos)
	})

	r.GET("/todo/:id", func(c *gin.Context) {
		var id, err = strconv.ParseUint(c.Params.ByName("id"), 10, 1)

		if err != nil {
			c.AbortWithError(http.StatusBadRequest, err)

			return
		}

		var todo Todo

		var value = db.First(&todo, id)

		c.JSON(http.StatusOK, value)
	})

	r.POST("/todo", func(c *gin.Context) {

		var todo = Todo{}

		if err := c.BindJSON(&todo); err != nil {
			c.AbortWithError(http.StatusBadRequest, err)

			return
		}

		db.Create(&Todo{Title: todo.Title, Content: todo.Content})

		c.JSON(http.StatusCreated, gin.H{"message": "Todo created."})
	})

	return r
}

func main() {
	r := setupRouter()

	r.Run(":4007")
}
