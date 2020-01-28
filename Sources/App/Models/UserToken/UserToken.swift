//
//  UserToken.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID(key: "id")
    var id: Int?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(id: Int? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension UserToken: MigrationProvider {
    static func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema)
            .field("id", .int, .identifier(auto: true))
            .field("value", .string, .required)
            .field("user_id", .int, .required, .references("users", "id"))
            .unique(on: "value")
            .create()
    }

    static func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Self.schema).delete()
    }
}

extension UserToken: ModelUserToken {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}
