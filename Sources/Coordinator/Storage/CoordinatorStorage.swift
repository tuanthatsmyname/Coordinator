//
//  CoordinatorStorage.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 05.12.2021.
//

import Foundation

public final class CoordinatorStorage: CoordinatorStoring {
    private var coordinators = [AnyObject]()

    public init() {}

    public func store(_ coordinator: AnyObject) {
        coordinators.append(coordinator)
    }

    public func remove(_ coordinator: AnyObject) {
        coordinators.removeAll { $0 === coordinator }
    }

    func removeAll() {
        coordinators.removeAll()
    }
}
