//
//  Coordinating.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 19.11.2021.
//

import Combine
import CombineExt
import CombineExtensions
import Foundation

public protocol Coordinating: AnyObject, Presentable {
    associatedtype CoordinationInput
    associatedtype CoordinationResult

    var childCoordinatorsStorage: CoordinatorStorage { get }
    var router: Routing { get }

    func start(with input: CoordinationInput) -> AnyPublisher<CoordinationResult, Never>
    func stop()
}

public extension Coordinating {
    func stop() {}
}
