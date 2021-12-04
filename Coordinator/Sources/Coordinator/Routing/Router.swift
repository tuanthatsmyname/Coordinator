//
//  Router.swift
//  
//
//  Created by Tuan Tu Do on 21.11.2021.
//

import UIKit

public final class Router: NSObject, Routing {
    public let navigationController: UINavigationController

    private var closures = [ViewControllerID: PopClosure]()

    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    public func present(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(module.presentable, animated: animated, completion: completion)
    }

    public func present(
        _ module: Presentable,
        animated: Bool,
        presentCompletion: (() -> Void)?,
        dismissCompletion: (() -> Void)?
    ) {
        let viewController = module.presentable
        viewController.presentationController?.delegate = self

        if let dismissCompletion = dismissCompletion {
            closures.updateValue(dismissCompletion, forKey: viewController.description)
        }

        navigationController.present(
            module.presentable,
            animated: animated,
            completion: presentCompletion
        )
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    public func push(
        _ module: Presentable,
        animated: Bool,
        pushCompletion: (() -> Void)?,
        popCompletion: (() -> Void)?
    ) {
        let viewController = module.presentable

        if let popCompletion = popCompletion {
            closures.updateValue(popCompletion, forKey: viewController.description)
        }

        navigationController.pushViewController(viewController, animated: animated)

        if let pushCompletion = pushCompletion {
            pushCompletion()
        }
    }

    public func pop(animated: Bool) {
        if let viewController = navigationController.popViewController(animated: animated) {
            executeCompletion(for: viewController.description) // TODO: do we really want this?
        }
    }

    public func setRootModule(_ module: Presentable) {
        navigationController.setViewControllers([module.presentable], animated: false)
    }

    public func popToRootModule(animated: Bool) {
        if let viewControllers = navigationController.popToRootViewController(animated: animated) {
            viewControllers.forEach {
                executeCompletion(for: $0.description)
            }
        }
    }
}

private extension Router {
    func executeCompletion(for viewControllerID: ViewControllerID) {
        guard let completion = closures.removeValue(forKey: viewControllerID) else { return }
        completion()
    }
}

extension Router {
    typealias ViewControllerID = String
    typealias PopClosure = () -> Void
    typealias DismissClosure = () -> Void
}

extension Router: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let viewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(viewController)
        else {
            return
        }

        executeCompletion(for: viewController.description)
    }
}

extension Router: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(
        _ presentationController: UIPresentationController
    ) {
        executeCompletion(for: presentationController.presentedViewController.description)
    }
}
