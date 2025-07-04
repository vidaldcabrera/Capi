import Foundation
import SpriteKit

extension SKTileMapNode {
    func addPhysicsToTileMap(entityManager: SKEntityManager) {
        for col in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                guard let tileDef = tileDefinition(atColumn: col, row: row) else { continue }
                if tileDef.userData?["noPhysics"] != nil { continue }
                tileDef.textures.first?.filteringMode = .nearest
                let ground = SceneEntity(named: "//Ground", entityManager: entityManager)
                entityManager.add(entity: ground)
            }
        }
    }
}
