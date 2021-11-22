//
//  ViewController.swift
//  coordinators
//
//  Created by Tuan Tu Do on 01.11.2021.
//

import Combine
import UIKit

class ViewController: UIViewController {
    let presentButtonTapped = PassthroughSubject<Void, Never>()
    let pushButtonTapped = PassthroughSubject<Void, Never>()
    let closeButtonTapped = PassthroughSubject<Void, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        let presentButton = UIButton()
        presentButton.setTitle("Present", for: .normal)
        presentButton.addTarget(self, action: #selector(onPresentButtonTap), for: .touchUpInside)

        view.addSubview(presentButton)
        presentButton.translatesAutoresizingMaskIntoConstraints = false
        presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let pushButton = UIButton()
        pushButton.setTitle("Push", for: .normal)
        pushButton.addTarget(self, action: #selector(onPushButtonTap), for: .touchUpInside)

        view.addSubview(pushButton)
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pushButton.topAnchor.constraint(equalTo: presentButton.bottomAnchor).isActive = true

        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: pushButton.bottomAnchor).isActive = true
    }

    @objc private func onPresentButtonTap() {
        presentButtonTapped.send(())
    }

    @objc private func onPushButtonTap() {
        pushButtonTapped.send(())
    }

    @objc private func onCloseButtonTap() {
        closeButtonTapped.send(())
    }
}
