//
//  QuestionsController.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Fluent
import Vapor

final class QuestionsController {
    
    func routes(_ app: Application) throws {
        try openRoutes(app)
        try protectedRoutes(app)
    }
    
    func openRoutes(_ app: Application) throws {
        app.get("projects", ":projectID", "questions", use: indexQuestions)
    }
    
    func protectedRoutes(_ app: Application) throws {
        let tokenProtected = app.grouped(UserToken.authenticator().middleware())
        tokenProtected.post("projects", ":projectID", "questions", use: createQuestion)
    }
    
    func indexQuestions(on req: Request) throws -> EventLoopFuture<[Question]> {
        Project.query(on: req.db).with(\.$questions)
            .filter(\.$id == req.parameters.get("projectID"))
            .first().unwrap(or: Abort(.notFound))
            .map { $0.$questions.eagerLoaded ?? [] }
    }
    
    func createQuestion(on req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let user = try req.auth.require(User.self)
        return Project.find(req.parameters.get("projectID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .guard({ $0.$owner.id == user.id }, else: Abort(.badRequest))
            .throwingFlatMap { project in
                let create = try req.content.decode(Question.Create.self)
                let question = try Question(title: create.title,
                                            body: create.body,
                                            answer: create.answer,
                                            projectID: project.requireID())
                return question.save(on: req.db).return(.ok)
        }
    }
    
}
