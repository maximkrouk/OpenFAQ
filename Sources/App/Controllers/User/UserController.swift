//
//  UserController.swift
//  App
//
//  Created by Maxim Krouk on 1/27/20.
//

import Fluent
import Vapor

class UserController {
    
    func routes(_ app: Application) throws {
        app.post("users", use: createUser)
    }
    
    func createUser(on req: Request) throws -> EventLoopFuture<User> {
        try User.Create.validate(req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword
        else { throw Abort(.badRequest, reason: "Passwords did not match") }
        
        let user = try User(firstName: create.firstName,
                            lastName: create.lastName,
                            email: create.email,
                            passwordHash: Bcrypt.hash(create.password),
                            projects: [])
        return user.save(on: req.db).map { user }
    }
}
