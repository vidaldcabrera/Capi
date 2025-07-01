import Foundation
import GameplayKit
import SpriteKit

class SceneEntity: GKEntity {
    init(named name: String, entityManager: SKEntityManager) {
        super.init()
        guard let sceneNode = SKReferenceNode(fileNamed: "\(name).sks") else {
            fatalError()
        }
        addComponent(GKSKNodeComponent(node: sceneNode))
        if let tileMap = sceneNode.childNode(withName: "*/Ground") as? SKTileMapNode {
            tileMap.addPhysicsToTileMap(entityManager: entityManager)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
