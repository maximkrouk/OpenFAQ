import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in "It works!" }
    app.get("hello") { req in "Hello, world!" }
    
    try UsersController().routes(app)
    try ProjectsController().routes(app)
    try QuestionsController().routes(app)
}
