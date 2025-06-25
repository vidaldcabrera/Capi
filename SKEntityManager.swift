//
//  SKEntityManager.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 11/06/25.
//

import Foundation
import GameplayKit

class SKEntityManager {
    private(set) var entities = Set<GKEntity>()

    func add(entity: GKEntity) {
        entities.insert(entity)
    }

    func remove(entity: GKEntity) {
        entities.remove(entity)
    }
}
