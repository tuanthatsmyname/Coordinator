//
//  CoordinatorStorage.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 19.11.2021.
//

import Foundation

// TODO: protocol
public final class CoordinatorStorage {
    private var coordinators: [AnyObject] = []

    public init() {}

    func store(_ coordinator: AnyObject) {
        coordinators.append(coordinator)
    }

    func remove(_ coordinator: AnyObject) {
        coordinators.removeAll { $0 === coordinator }
        print("counter: \(coordinators.count)")
    }

    func removeAll() {
        coordinators.removeAll()
    }
}
