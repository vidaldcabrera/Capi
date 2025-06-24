import Foundation
import GameplayKit
import SpriteKit

class SceneEntity: GKEntity {
    init(named: String, entityManager: SKEntityManager){
        super.init()
        if let sceneNode = SKReferenceNode(fileNamed: named) {
            self.addComponent(GKSKNodeComponent(node: sceneNode))
            
            if let tileMapNode = sceneNode.childNode(withName: "*/ground") as? SKTileMapNode {
                tileMapNode.addPhysicsToTileMap(entityManager: entityManager)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
