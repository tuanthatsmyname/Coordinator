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

private extension Coordinating {
    func store<T: Coordinating>(_ coordinator: T) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [weak self] subscriber in
            if let storeResult = self?.childCoordinatorsStorage.store(coordinator) {
                subscriber.send(storeResult)
            }

            return AnyCancellable {}
        }
    }

    func remove<T: Coordinating>(_ coordinator: T) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [weak self] subscriber in
            if let removeResult = self?.childCoordinatorsStorage.remove(coordinator) {
                subscriber.send(removeResult)
            }

            return AnyCancellable {}
        }
    }

    func coordinate<T: Coordinating>(
        to coordinator: T,
        with input: T.CoordinationInput
    ) -> AnyPublisher<T.CoordinationResult, Never> {
        store(coordinator)
            .flatMap { _ in
                coordinator.start(with: input)
            }
            .flatMap(weak: self) { unwrappedSelf, coordinationResult in
                unwrappedSelf.remove(coordinator)
                    .map { coordinationResult }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

public extension Coordinating {
    func push<T: Coordinating, U>(
        _ coordinator: T,
        with input: T.CoordinationInput,
        animated: Bool
    ) -> AnyPublisher<PushCoordinationResult<U>, Never> where U == T.CoordinationResult {
        // no retain cycle
//        push(coordinator.presentable, animated: true)
//            .map { _ in PushCoordinationResult.dismissed(withGesture: true) }
//            .eraseToAnyPublisher()

        push(coordinator.presentable, animated: animated)
            .flatMap(
                weak: self
            ) { [weak coordinator] unwrappedSelf, pushAction -> AnyPublisher<PushCoordinationResult<U>, Never> in
                guard let coordinator = coordinator else {
                    print("WTF")
                    return Empty().eraseToAnyPublisher()
                }

                switch pushAction {
                case .pushed:
                    return unwrappedSelf.coordinate(to: coordinator, with: input)
                        .map(PushCoordinationResult.finished)
                        .eraseToAnyPublisher()
                case .popped:
                    break
                }

                return Empty().eraseToAnyPublisher()
            }

//        push(coordinator.presentable, animated: animated)
//            .flatMap { [weak self] pushAction -> AnyPublisher<PushCoordinationResult<U>, Never> in
//                guard let self = self else { return Empty().eraseToAnyPublisher() }
//
//                switch pushAction {
//                case .pushed:
//                    return self.coordinate(to: coordinator, with: input)
//                        .map(PushCoordinationResult.finished)
//                        .eraseToAnyPublisher()
//                case .popped:
//                    return AnyPublisher<PushCoordinationResult<U>, Never>.create { subscriber in
//                        subscriber.send(PushCoordinationResult.dismissed(withGesture: true))
//                        return AnyCancellable {}
//                    }
//                    .flatMap { result in
//                        self.remove(coordinator)
//                            .map { result }
//                            .eraseToAnyPublisher()
//                    }
//                    .eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
    }
}

enum PushAction {
    case pushed
    case popped
}

private extension Coordinating {
    func push(_ presentable: Presentable, animated: Bool) -> AnyPublisher<PushAction, Never> {
        AnyPublisher.create { [weak self] subscriber in
            self?.router.push(
                presentable,
                animated: animated,
                pushCompletion: { subscriber.send(.pushed) },
                popCompletion: { subscriber.send(.popped) }
            )

            return AnyCancellable {}
        }
    }
}

public enum PushCoordinationResult<T> {
    case dismissed(withGesture: Bool)
    case finished(T)
}

//public protocol Coordinator: StartableCoordinator, StopableCoordinator {}
//
//public protocol StartableCoordinator {
//    var a: String { get }
//}
//
//public protocol StopableCoordinator {
//    var b: String { get }
//}
