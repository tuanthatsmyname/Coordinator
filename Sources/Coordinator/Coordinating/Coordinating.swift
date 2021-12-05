//
//  Coordinating.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 05.12.2021.
//

import Combine

public protocol Coordinating: AnyObject, Presentable {
    associatedtype CoordinationInput
    associatedtype CoordinationResult

    var childCoordinatorsStorage: CoordinatorStoring { get }
    var router: Routing { get }

    func start(with input: CoordinationInput) -> AnyPublisher<CoordinationResult, Never>
    func stop()
}

public extension Coordinating {
    func stop() {}
}
