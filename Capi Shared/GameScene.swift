import SpriteKit
import GameplayKit
import Foundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
        
        
        
        // Cria o mosquito e adiciona na cena
        mosquito = MosquitoEntity(position: CGPoint(x: 100, y: 100))
        
        if let mosquitoNode = mosquito?.spriteNode {
            addChild(mosquitoNode)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        handleMosquitoContact(contact)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
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

extension GameScene {

    func handleMosquitoContact(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        // Garante sempre a mesma ordem: menor categoria primeiro
        if bodyA.categoryBitMask < bodyB.categoryBitMask {
            firstBody = bodyA
            secondBody = bodyB
        } else {
            firstBody = bodyB
            secondBody = bodyA
        }
        
        // Checa: Player tocando Mosquito
        if firstBody.categoryBitMask == PhysicsCategory.player &&
            secondBody.categoryBitMask == PhysicsCategory.mosquito {
            
            if let mosquitoEntity = mosquito {
                mosquitoEntity.mosquitoStateMachine.enter(MosquitoAttackingState.self)
            }
        }
    }
    
}
