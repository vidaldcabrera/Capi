import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var chao: SKTileMapNode?
    var entities: [GKEntity] = []


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
        
        
        let spiderTexture = SKTexture(imageNamed: "_CrouchTransition")
        let spider = SpiderEntity(texture: spiderTexture, position: CGPoint(x: 0.5, y: 0.5))
         
        if let node = spider.component(ofType: RenderComponent.self)?.node {
            addChild(node)
        }
        entities.append(spider)

        
    }

    override func didMove(to view: SKView) {
        setUpScene()
    }

    override func update(_ currentTime: TimeInterval) {
        for entity in entities {
            entity.update(deltaTime: currentTime)
        }
    }

}

extension GameScene {
   
}
