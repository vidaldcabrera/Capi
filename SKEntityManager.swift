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
    
}
