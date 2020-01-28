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

    init(id: String? = nil, title: String, description: String, owner: User, questions: [Question]) {
        self.id = id
        self.title = title
        self.description = description
        self.owner = owner
        self.questions = questions
    }
}

extension Project: MigrationProvider {
    static func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema)
            .field("id", .uuid, .identifier(auto: true))
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("owner_id", .uuid, .references("projects", "id"))
            .create()
    }
    
    static func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema).delete()
    }
}
