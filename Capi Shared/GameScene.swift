import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var chao: SKTileMapNode?
    var mosquito: MosquitoEntity?

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

        // Cria o mosquito e adiciona na cena
        mosquito = MosquitoEntity(position: CGPoint(x: 100, y: 100))
        
        if let mosquitoNode = mosquito?.spriteNode {
            addChild(mosquitoNode)
        }
    }

    override func didMove(to view: SKView) {
        setUpScene()
    }

    private var lastUpdateTime: TimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {
        var deltaTime = currentTime - lastUpdateTime
        if lastUpdateTime == 0 {
            deltaTime = 0
        }
        lastUpdateTime = currentTime

        mosquito?.mosquitoStateMachine.update(deltaTime: deltaTime)
    }
}
