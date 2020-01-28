//
//  MigrationProvider.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Fluent

private struct _Migration<T>: Migration {
    var preparation: (Database) -> EventLoopFuture<Void>
    var revertion: (Database) -> EventLoopFuture<Void>
    func prepare(on database: Database) -> EventLoopFuture<Void> { preparation(database) }
    func revert(on database: Database) -> EventLoopFuture<Void> { revertion(database) }
}

protocol MigrationProvider {
    static func prepare(on database: Database) -> EventLoopFuture<Void>
    static func revert(on database: Database) -> EventLoopFuture<Void>
}

extension MigrationProvider {
    static var migration: Migration {
        _Migration<Self>(preparation: prepare, revertion: revert)
    }
}
