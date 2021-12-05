//
//  Routing.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 05.12.2021.
//

import UIKit

public protocol Routing {
    var navigationController: UINavigationController { get }

    func present(
        _ module: Presentable,
        animated: Bool,
        presentCompletion: (() -> Void)?,
        dismissCompletion: (() -> Void)?
    )

    func dismiss(animated: Bool, completion: (() -> Void)?)

    func push(
        _ module: Presentable,
        animated: Bool,
        pushCompletion: (() -> Void)?,
        popCompletion: (() -> Void)?
    )

    func pop(animated: Bool)

    func setRootModule(_ module: Presentable)
    func popToRootModule(animated: Bool)
}
