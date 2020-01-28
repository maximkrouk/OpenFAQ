//
//  User.swift
//  App
//
//  Created by Maxim Krouk on 1/27/20.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?

    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String
    
    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String
    
    @Children(for: \.$owner)
    var projects: [Project]

    init() { }

    init(id: UUID? = nil, firstName: String, lastName: String,
         email: String, passwordHash: String, projects: [Project]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.projects = projects
    }
    
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

extension User: MigrationProvider {
    static func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema)
            .field("id", .uuid, .identifier(auto: false))
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .create()
    }
    
    static func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema).delete()
    }
}

extension User {
    struct Create: Content {
        var firstName: String
        var lastName: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("lastName", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: ModelUser {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
