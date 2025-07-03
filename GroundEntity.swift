import Foundation
import SpriteKit
import GameplayKit

/// Entidade que representa o chão baseado em um tile map
class GroundEntity: GKEntity {
    init(tileMap: SKTileMapNode) {
        super.init()

        // Adiciona física ao tile map de chão
        tileMap.addPhysicsToTileMap(entityManager: SKEntityManager(scene: tileMap.scene as! GameScene))

        // Componente de nó para inserção na cena
        addComponent(GKSKNodeComponent(node: tileMap))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
