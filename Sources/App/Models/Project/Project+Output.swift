//
//  Project+Output.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Vapor

extension Project {
    struct Output {
        var id: String?
        var title: String
        var description: String
        var ownerID: UUID?
    }
}
