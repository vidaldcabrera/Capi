import Foundation
import SpriteKit
import GameplayKit

class SKEntityManager {
    var entities = Set<GKEntity>()
    var scene: SKScene

    init(scene: SKScene) {
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
    
    func update(_ deltaTime: TimeInterval) {
        for entity in entities {
            entity.update(deltaTime: deltaTime)
        }
    }

}
