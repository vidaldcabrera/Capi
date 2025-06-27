<<<<<<< HEAD
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
=======
import Foundation
import SpriteKit
import GameplayKit

class SKEntityManager {
    
    var entities = Set<GKEntity>()
    
    var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
            scene.addChild(node)
        }
        
    }
    
    func remove(entity: GKEntity) {
        entities.remove(entity)
    }
    
>>>>>>> feature/capi-mec
}
