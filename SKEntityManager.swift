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

    func getEntity(named name: String) -> GKEntity? {
        return entities.first(where: { entity in
            if let nodeComponent = entity.component(ofType: GKSKNodeComponent.self) {
                return nodeComponent.node.name == name
            }
            return false
        })
    }
    
    func remove(entity: GKEntity) {
        entities.remove(entity)
    }
}
