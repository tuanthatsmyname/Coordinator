//
//  Publisher+handleCompletion.swift
//  Coordinator
//
//  Created by Tuan Tu Do on 19.11.2021.
//

import Combine

public extension Publisher {
    func handleCompletion(
        _ completion: @escaping (Subscribers.Completion<Self.Failure>) -> Void
    ) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: completion)
    }
}
