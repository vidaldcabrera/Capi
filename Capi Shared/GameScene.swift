import SpriteKit

class GameScene: SKScene {

    var chao: SKTileMapNode?

    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            fatalError("Failed to load GameScene.sks")
        }
        scene.scaleMode = .aspectFill
        return scene
    }

    func setUpScene() {
        backgroundColor = .cyan

        // Recupera o chão
        chao = childNode(withName: "chao") as? SKTileMapNode
        if let chao = chao {
            let physicsBody = SKPhysicsBody(edgeLoopFrom: chao.frame)
            physicsBody.categoryBitMask = 0x1 << 1
            physicsBody.contactTestBitMask = 0xFFFFFFFF
            physicsBody.collisionBitMask = 0xFFFFFFFF
            physicsBody.isDynamic = false
            chao.physicsBody = physicsBody
        }

        
    }

    override func didMove(to view: SKView) {
        setUpScene()
    }

    override func update(_ currentTime: TimeInterval) {}
}

extension GameScene {
   
}
