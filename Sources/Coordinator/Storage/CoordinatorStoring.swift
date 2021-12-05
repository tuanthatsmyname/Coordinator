//
//  CoordinatorStoring.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 05.12.2021.
//

import Foundation

public protocol CoordinatorStoring {
    func store(_ coordinator: AnyObject)
    func remove(_ coordinator: AnyObject)
}
