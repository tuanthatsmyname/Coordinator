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

    init(router: Routing) {
        self.router = router
    }

    func start(with input: CoordinationInput) -> AnyPublisher<CoordinationResult, Never> {
        handleActions()

        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }

    private func handleActions() {
//        viewController.presentButtonTapped
//
//        viewController.pushButtonTapped
    }
}

extension TestingCoordinator {
    struct CoordinationInput {}
    struct CoordinationResult {}
}
