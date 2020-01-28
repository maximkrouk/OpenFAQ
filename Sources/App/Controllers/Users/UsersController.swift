//
//  UserController.swift
//  App
//
//  Created by Maxim Krouk on 1/27/20.
//

import Fluent
import Vapor

final class UsersController {
    
    func routes(_ app: Application) throws {
        try openRoutes(app)
        try protectedRoutes(app)
    }
    
    func openRoutes(_ app: Application) throws {
        app.post("users", use: createUser)
    }
    
    func protectedRoutes(_ app: Application) throws {
        let tokenProtected = app.grouped(UserToken.authenticator().middleware())
        let passwordProtected = app.grouped(User.authenticator().middleware())
        passwordProtected.post("login", use: loginUser)
        
        tokenProtected.get("me") { req in
            try req.auth.require(User.self).output
        }
    }
    
    func createUser(on req: Request) throws -> EventLoopFuture<UserToken.Output> {
        try User.Create.validate(req)
        let create = try req.content.decode(User.Create.self)
        return req.db.query(User.self)
            .filter(\.$email == create.email).first()
            .guard({ $0 == nil },
                   else: Abort(.badRequest, reason: "User with this email already exists."))
            .guard({ _ in create.password == create.confirmPassword},
                   else: Abort(.badRequest, reason: "Passwords did not match"))
            .throwingFlatMap { _ in
                let user = try User(id: UUID(),
                                    firstName: create.firstName,
                                    lastName: create.lastName,
                                    email: create.email,
                                    passwordHash: Bcrypt.hash(create.password))
                let token = try user.generateToken()
                let database = req.db
                return user
                    .save(on: database)
                    .and(token.save(on: database))
                    .return(token.output)
            }
    }
    
    
    func loginUser(on req: Request) throws -> EventLoopFuture<UserToken.Output> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token
            .save(on: req.db)
            .return(token.output)
    }
}
