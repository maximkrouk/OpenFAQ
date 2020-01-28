//
//  UserToken+Output.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension UserToken {
    struct Output: Content {
        var userID: UUID?
        var value: String
    }
    
    var output: Output { .init(userID: $user.id, value: value) }
}
