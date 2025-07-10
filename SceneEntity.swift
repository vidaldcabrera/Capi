import Foundation
import GameplayKit
import SpriteKit

class SceneEntity: GKEntity {
    init(named fileName: String, entityManager: SKEntityManager) {
        super.init()

        // Carrega o conteúdo do arquivo .sks como SKReferenceNode
        if let referenceNode = SKReferenceNode(fileNamed: fileName) {
            // Força o carregamento do conteúdo referenciado
            SKReferenceNode.load()
            
            // Centraliza a posição do node na origem da cena
            referenceNode.position = .zero

            // Adiciona o node à entidade
            self.addComponent(GKSKNodeComponent(node: referenceNode))

            // Adiciona física ao tileMap "Ground", se existir
            if let tileMapNode = referenceNode.childNode(withName: "*/Ground") as? SKTileMapNode {
                tileMapNode.addPhysicsToTileMap(entityManager: entityManager)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

