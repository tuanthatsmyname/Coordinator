//
//  Coordinating+Present.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 05.12.2021.
//

import Combine
import CombineExt
import CombineExtensions

public enum PresentCoordinationResult<T> {
    case dismissedWithGesture
    case finished(T)
}

public extension Coordinating {
    func present<T: Coordinating>(
        _ coordinator: T,
        with input: T.CoordinationInput,
        animated: Bool
    ) -> AnyPublisher<PresentCoordinationResult<T.CoordinationResult>, Never> {
        store(coordinator)
            .flatMap(weak: self, weak: coordinator) { unwrappedSelf, coordinator, _ in
                unwrappedSelf.present(coordinator, animated: animated)
            }
            .flatMap(weak: self, weak: coordinator) { unwrappedSelf, coordinator, presentAction in
                switch presentAction {
                case .presented:
                    return unwrappedSelf.start(coordinator, with: input)
                        .map(PresentCoordinationResult.finished)
                        .eraseToAnyPublisher()
                case .dismissedWithGesture:
                    return unwrappedSelf.remove(coordinator)
                        .map { PresentCoordinationResult.dismissedWithGesture }
                        .eraseToAnyPublisher()
                }
            }
    }

    func dismiss(animated: Bool) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [weak self] subscriber in
            self?.router.dismiss(
                animated: animated,
                completion: {
                    subscriber.send(())
                }
            )

            return AnyCancellable {}
        }
    }
}

private enum PresentAction {
    case presented
    case dismissedWithGesture
}

private extension Coordinating {
    func present(
        _ presentable: Presentable,
        animated: Bool
    ) -> AnyPublisher<PresentAction, Never> {
        AnyPublisher.create { [weak self] subscriber in
            self?.router.present(
                presentable,
                animated: animated,
                presentCompletion: { subscriber.send(.presented) },
                dismissCompletion: { subscriber.send(.dismissedWithGesture) }
            )

            return AnyCancellable {}
        }
    }
}

