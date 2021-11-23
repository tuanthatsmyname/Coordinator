//
//  TestingCoordinator.swift
//  coordinators
//
//  Created by Tuan Tu Do on 21.11.2021.
//

import Coordinator
import Combine
import UIKit

final class TestingCoordinator: Coordinating {
    let router: Routing
    let childCoordinatorsStorage = CoordinatorStorage()

    lazy var viewController: ViewController = {
        ViewController()
    }()

    lazy var presentable: UIViewController = {
        viewController
    }()

    private var cancellables = Set<AnyCancellable>()

    init(router: Routing) {
        self.router = router
    }

    func start(with input: CoordinationInput) -> AnyPublisher<CoordinationResult, Never> {
        handleActions()



        return viewController.closeButtonTapped
            .flatMap(weak: self) { unwrappedSelf, _ -> AnyPublisher<Void, Never> in
                // this should be done in the parent coordinator
                AnyPublisher<Void, Never>.create { subscriber in
                    subscriber.send(unwrappedSelf.router.pop(animated: true))
                    return AnyCancellable {}
                }
            }
            .print("close")
            .map { CoordinationResult.closed }
            .eraseToAnyPublisher()
    }

    private func handleActions() {}
}

extension TestingCoordinator {
    struct CoordinationInput {}

    enum CoordinationResult {
        case closed
    }
}
