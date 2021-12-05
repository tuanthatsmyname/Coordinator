//
//  Coordinating+Push.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 05.12.2021.
//

import Combine
import CombineExt
import CombineExtensions

public enum PushCoordinationResult<T> {
    case poppedWithGesture
    case finished(T)
}

public extension Coordinating {
    func push<T: Coordinating>(
        _ coordinator: T,
        with input: T.CoordinationInput,
        animated: Bool
    ) -> AnyPublisher<PushCoordinationResult<T.CoordinationResult>, Never> {
        store(coordinator)
            .flatMap(weak: self, weak: coordinator) { unwrappedSelf, coordinator, _ in
                unwrappedSelf.push(coordinator.presentable, animated: animated)
            }
            .flatMap(weak: self, weak: coordinator) { unwrappedSelf, coordinator, pushAction in
                switch pushAction {
                case .pushed:
                    return unwrappedSelf.coordinate(to: coordinator, with: input)
                        .map(PushCoordinationResult.finished)
                        .eraseToAnyPublisher()
                case .poppedWithGesture:
                    return unwrappedSelf.remove(coordinator)
                        .map { PushCoordinationResult.poppedWithGesture }
                        .eraseToAnyPublisher()
                }
            }
    }

    func pop(animated: Bool) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [weak self] subscriber in
            if let popResult = self?.router.pop(animated: animated) {
                subscriber.send(popResult)
            }

            return AnyCancellable {}
        }
    }
}

private enum PushAction {
    case pushed
    case poppedWithGesture
}

private extension Coordinating {
    func push(
        _ presentable: Presentable,
        animated: Bool
    ) -> AnyPublisher<PushAction, Never> {
        AnyPublisher.create { [weak self] subscriber in
            self?.router.push(
                presentable,
                animated: animated,
                pushCompletion: { subscriber.send(.pushed) },
                popCompletion: { subscriber.send(.poppedWithGesture) }
            )

            return AnyCancellable {}
        }
    }
}
