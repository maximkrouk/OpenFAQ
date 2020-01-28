//
//  Question.swift
//  App
//
//  Created by Maxim Krouk on 1/27/20.
//

import Fluent
import Vapor

final class Question: Model, Content {
    static let schema = "questions"
    
    @ID(key: "id")
    var id: Int?

    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String
    
    @Field(key: "answer")
    var answer: String
    
    @Parent(key: "project_id")
    var project: Project

    init() { }

    init(id: Int? = nil, title: String, body: String, answer: String, projectID: String) {
        self.id = id
        self.title = title
        self.body = body
        self.answer = answer
        self.$project.id = projectID
    }
}

extension Question: MigrationProvider {
    static func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema)
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("body", .string, .required)
            .field("answer", .string, .required)
            .field("project_id", .string, .references("projects", "id"))
            .create()
    }
    
    static func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema).delete()
    }
}
