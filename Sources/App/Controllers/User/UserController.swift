//
//  UserController.swift
//  App
//
//  Created by Maxim Krouk on 1/27/20.
//

import Fluent
import Vapor

class UserController {
    
    func allRoutes(_ app: Application) throws {
        try openRoutes(app)
        try protectedRoutes(app)
    }
    
    func openRoutes(_ app: Application) throws {
        app.post("users", use: createUser)
        app.post("login", use: loginUser)
    }
    
    func protectedRoutes(_ app: Application) throws {
        let protected = app.grouped(UserToken.authenticator().middleware())
        protected.get("me") { req in
            try req.auth.require(User.self)
        }
    }
    
    func createUser(on req: Request) throws -> EventLoopFuture<User> {
        try User.Create.validate(req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword
        else { throw Abort(.badRequest, reason: "Passwords did not match") }
        
        let user = try User(id: UUID(),
                            firstName: create.firstName,
                            lastName: create.lastName,
                            email: create.email,
                            passwordHash: Bcrypt.hash(create.password),
                            projects: [])
        return user.save(on: req.db).map { user }
    }
    
    func loginUser(on req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db).map { token }
    }
}
