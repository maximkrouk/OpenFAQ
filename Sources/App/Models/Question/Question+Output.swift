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
        var projectId: String
    }
    var output: Output {
        .init(id: id, title: title, body: body,
              answer: answer, projectId: $project.id)
    }
}
