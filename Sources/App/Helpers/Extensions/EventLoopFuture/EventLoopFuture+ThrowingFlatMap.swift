//
//  EventLoopFuture+ThrowingFlatMap.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import NIO

extension EventLoopFuture {
    func throwingFlatMap<T>(_ closure: @escaping ((Value) throws -> EventLoopFuture<T>)) -> EventLoopFuture<T> {
        flatMap { value in
            do { return try closure(value) }
            catch { return self.eventLoop.makeFailedFuture(error) }
        }
    }
}
