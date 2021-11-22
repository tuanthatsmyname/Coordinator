//
//  SceneDelegate.swift
//  coordinators
//
//  Created by Tuan Tu Do on 01.11.2021.
//

import Coordinator
import Combine
import CombineExtensions
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let appRouter = Router()
    private var appCoordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions:
        UIScene.ConnectionOptions
    ) {
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)

        appCoordinator = AppCoordinator(router: appRouter)
        appCoordinator?.start(with: .init(window: window))
            .sink()
            .store(in: &cancellables)
    }
}
