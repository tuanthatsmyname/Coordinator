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
    private let viewController = ViewController()

    lazy var presentable: UIViewController = {
        viewController
    }()

    let childCoordinatorsStorage = CoordinatorStorage()
    let router: Routing

    private var cancellables = Set<AnyCancellable>()

    init(router: Routing) {
        self.router = router
    }

    func start(with input: CoordinationInput) -> AnyPublisher<CoordinationResult, Never> {
        router.push(presentable, animated: true, pushCompletion: nil, popCompletion: nil)

        return viewController.closeButtonTapped
            .first()
            .handleEvents(
                receiveOutput: { [weak self] in
                    self?.router.pop(animated: true)
                }
            )
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
