//
//  AppCoordinator.swift
//  coordinators
//
//  Created by Tuan Tu Do on 21.11.2021.
//

import Coordinator
import Combine
import CombineExtensions
import UIKit

final class AppCoordinator: Coordinating {
    var presentable: UIViewController = UIViewController()

    let childCoordinatorsStorage = CoordinatorStorage()

    let router: Routing
    private var cancellables = Set<AnyCancellable>()

    init(router: Routing) {
        self.router = router
    }

    func start(with input: CoordinationInput) -> AnyPublisher<CoordinationResult, Never> {
        let viewController = ViewController()
        router.setRootModule(viewController.presentable)

        input.window?.rootViewController = router.navigationController
        input.window?.makeKeyAndVisible()

        handleActions(from: viewController, on: router.navigationController)

        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }

    func stop() {}
}

private extension AppCoordinator {
    func handleActions(
        from viewModel: ViewController,
        on navigationController: UINavigationController
    ) {
        viewModel.pushButtonTapped
            .flatMap(weak: self) { unwrappedSelf, _ in
                unwrappedSelf.coordinate(
                    to: TestingCoordinator(router: unwrappedSelf.router),
                    with: .init()
                )
            }
            .sink()
            .store(in: &cancellables)
    }
}

extension AppCoordinator {
    struct CoordinationInput {
        let window: UIWindow?
    }

    struct CoordinationResult {}
}
