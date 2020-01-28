import Fluent
import Vapor

func routes(_ app: Application) throws {
    try HomeController().routes(app)
    try UsersController().routes(app)
    try ProjectsController().routes(app)
    try QuestionsController().routes(app)
}
