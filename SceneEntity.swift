import Foundation
import GameplayKit
import SpriteKit

class SceneEntity: GKEntity {
    init(named fileName: String, entityManager: SKEntityManager) {
        super.init()
        
        if let sceneNode = SKReferenceNode(fileNamed: fileName) {
            
            self.addComponent(GKSKNodeComponent(node: sceneNode))
            
            // Só adiciona física ao tilemap "Ground", se existir
            if let tileMapNode = sceneNode.childNode(withName: "*/Ground") as? SKTileMapNode {
                tileMapNode.addPhysicsToTileMap(entityManager: entityManager)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
