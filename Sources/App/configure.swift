import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "admin",
        password: Environment.get("DATABASE_PASSWORD") ?? "PA55W0RD-4-0PENFAQ",
        database: Environment.get("DATABASE_NAME") ?? "openfaq"
    ), as: .psql)

    app.migrations.add(User.migration)
    app.migrations.add(Project.migration)
    app.migrations.add(Question.migration)
    app.migrations.add(UserToken.migration)
    
    try app.migrator.setupIfNeeded().wait()
    try app.migrator.prepareBatch().wait()
    
    // register routes
    try routes(app)
}
