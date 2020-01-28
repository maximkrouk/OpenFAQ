//
//  User+Output.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension User {
    struct Output: Content {
        var id: UUID?
        var firstName: String
        var lastName: String
        var email: String
    }
    var output: Output {
        .init(id: id,
              firstName: firstName,
              lastName: lastName,
              email: email)
    }
}
