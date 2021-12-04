//
//  Coordinating+Storage.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 04.12.2021.
//

import Combine
import CombineExt
import CombineExtensions

extension Coordinating {
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
        coordinator.start(with: input)
            .flatMap(
                weak: self,
                weak: coordinator
            ) { unwrappedSelf, coordinator, coordinationResult in
                unwrappedSelf.remove(coordinator)
                    .map { coordinationResult }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
