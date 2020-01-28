//
//  Question+Create.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension Question {
    struct Create: Content {
        var title: String
        var body: String
        var answer: String
        var projectId: String
    }
}
