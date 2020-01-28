//
//  Project.swift
//  App
//
//  Created by Maxim Krouk on 1/27/20.
//

import Fluent
import Vapor

final class Project: Model, Content {
    static let schema = "projects"
    
    @ID(key: "id")
    var id: String?

    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Parent(key: "owner_id")
    var owner: User
    
    @Children(for: \.$project)
    var questions: [Question]

    init() { }

    init(id: String? = nil, title: String, description: String, ownerId: UUID) {
        self.id = id
        self.title = title
        self.description = description
        self.$owner.id = ownerId
    }
}

extension Project: MigrationProvider {
    static func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema)
            .field("id", .string, .identifier(auto: false))
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("owner_id", .uuid, .references("users", "id"))
            .create()
    }
    
    static func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema).delete()
    }
}
