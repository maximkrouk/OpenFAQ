//
//  Question+Output.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension Question {
    struct Output: Content {
        var id: Int?
        var title: String
        var body: String
        var answer: String
        var projectID: String
    }
    var output: Output {
        .init(id: id, title: title, body: body,
              answer: answer, projectID: $project.id)
    }
}
