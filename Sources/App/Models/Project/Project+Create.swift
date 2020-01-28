//
//  Project+Create.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension Project {
    struct Create: Content {
        var id: String
        var title: String
        var description: String
    }
}

extension Project.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: String.self, is: .characterSet(
            CharacterSet.decimalDigits.union(.lowercaseLetters)))
    }
}
