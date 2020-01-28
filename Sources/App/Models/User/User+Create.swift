//
//  User+Create.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

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
