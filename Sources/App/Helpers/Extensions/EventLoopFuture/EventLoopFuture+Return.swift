//
//  EventLoopFuture+Return.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import NIO

extension EventLoopFuture {
    func `return`<T>(_ value: T) -> EventLoopFuture<T> { map { _ in value } }
    func `return`<T>(_ value: @escaping () -> T) -> EventLoopFuture<T> { map { _ in value() } }
}
