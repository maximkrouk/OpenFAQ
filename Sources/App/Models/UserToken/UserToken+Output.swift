//
//  UserToken+Output.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension UserToken {
    struct Output: Content {
        var userId: UUID?
        var value: String
    }
    
    var output: Output { .init(userId: $user.id, value: value) }
}
