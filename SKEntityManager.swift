import Foundation
import SpriteKit
import GameplayKit

class SKEntityManager {
    private(set) var entities = Set<GKEntity>()
    unowned let scene: SKScene

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
}
