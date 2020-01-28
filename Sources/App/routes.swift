import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in "It works!" }
    app.get("hello") { req in "Hello, world!" }
    
    try UserController().allRoutes(app)
}
