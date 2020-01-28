//
//  ProjectsController.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Fluent
import Vapor

final class ProjectsController {
    
    func routes(_ app: Application) throws {
        try openRoutes(app)
        try protectedRoutes(app)
    }
    
    func openRoutes(_ app: Application) throws {
        app.get("projects", use: indexProjects)
    }
    
    func protectedRoutes(_ app: Application) throws {
        let tokenProtected = app.grouped(UserToken.authenticator().middleware())
        tokenProtected.post("projects", use: createProject)
    }
    
    func indexProjects(on req: Request) throws -> EventLoopFuture<[Project]> {
        Project.query(on: req.db).all()
    }
    
    func createProject(on req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let user = try req.auth.require(User.self)
        
        try Project.Create.validate(req)
        let create = try req.content.decode(Project.Create.self)
        let project = try Project(id: create.id,
                                  title: create.title,
                                  description: create.description,
                                  ownerId: user.requireID())
        return project.save(on: req.db).return(.ok)
    }
    
}
