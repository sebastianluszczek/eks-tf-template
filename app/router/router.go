package router

import (
	"service_app/controller"

	"github.com/gofiber/fiber/v2"
)

func SetupRoutes(app *fiber.App) {
	router := app.Group("/api")

	note := router.Group("/note")
	// Create a Note
	note.Post("/", controller.CreateNote)
	// Read all Notes
	note.Get("/", controller.GetNotes)
	// Read one Note
	note.Get("/:noteId", controller.GetNotes)
	// // Update one Note
	// note.Put("/:noteId", func(c *fiber.Ctx) error {})
	// // Delete one Note
	// note.Delete("/:noteId", func(c *fiber.Ctx) error {})
}