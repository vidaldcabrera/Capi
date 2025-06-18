import Foundation
import GameplayKit
import SpriteKit

class SceneEntity: GKEntity {
    init (named: String, entityManager: SKEntityManager) {
        super.init()
        if let scenarioNode = SKReferenceNode(fileNamed: named) {
            self.addComponent(GKSKNodeComponent(node: scenarioNode))
            
            if let tileMapNode = scenarioNode.childNode(withName: "*/Ground") as?
                SKTileMapNode {
                tileMapNode.addPhyisicsToTileMap(entityManager: entityManager)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not bee implemented")
    }
}
