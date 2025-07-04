import Foundation
import SpriteKit

extension SKTileMapNode {
    func addPhysicsToTileMap(entityManager: SKEntityManager) {
        for col in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                guard let tileDef = tileDefinition(atColumn: col, row: row) else { continue }
                if tileDef.userData?["noPhysics"] != nil { continue }

                let tileSize = self.tileSize
                let x = CGFloat(col) * tileSize.width + tileSize.width / 2 - self.mapSize.width / 2
                let y = CGFloat(row) * tileSize.height + tileSize.height / 2 - self.mapSize.height / 2

                let tileNode = SKNode()
                tileNode.position = CGPoint(x: x, y: y)

                tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = PhysicsCategory.ground
                tileNode.physicsBody?.collisionBitMask = PhysicsCategory.player
                tileNode.physicsBody?.contactTestBitMask = 0

                self.addChild(tileNode)
            }
        }
    }
}
