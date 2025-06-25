import Foundation
import SpriteKit
import GameplayKit

class BatEntity: GKEntity {
    
    var batStateMachine: GKStateMachine!
    var spriteNode: SKSpriteNode!
    let baseYPosition: CGFloat
    
    // Arrays de frames por animação
    var flyFrames: [SKTexture] = []
    var attackFrames: [SKTexture] = []
    var deathFrames: [SKTexture] = []

    init(position: CGPoint) {
        self.baseYPosition = position.y
        super.init()
        
        // Carregar os frames de cada animação
        flyFrames = loadFrames(from: "BatFlying", frameCount: 8)
        attackFrames = loadFrames(from: "BatAttack", frameCount: 11)
        deathFrames = loadFrames(from: "BatDeath", frameCount: 12)
        
        // Criar o sprite node com o primeiro frame da animação de voo
        spriteNode = SKSpriteNode(texture: flyFrames.first)
        spriteNode.position = position
        spriteNode.name = "bat"
        
        // Configuração da física
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.isDynamic = false
        spriteNode.physicsBody?.affectedByGravity = false
        
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.bat
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
        spriteNode.physicsBody?.collisionBitMask = PhysicsCategory.ground

        
        // Estados
        let fly = BatFlyingState(bat: self, leftLimit: position.x - 50, rightLimit: position.x + 50)
        let attack = BatAttackingState(bat: self)
        let death = BatDyingState(bat: self)
        
        batStateMachine = GKStateMachine(states: [fly, attack, death])
        batStateMachine.enter(BatFlyingState.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Função genérica pra cortar spritesheets horizontais
    private func loadFrames(from imageName: String, frameCount: Int) -> [SKTexture] {
        let texture = SKTexture(imageNamed: imageName)
        let frameWidth = 1.0 / CGFloat(frameCount)
        var frames: [SKTexture] = []

        for i in 0..<frameCount {
            let frameRect = CGRect(x: CGFloat(i) * frameWidth, y: 0, width: frameWidth, height: 1.0)
            let frameTexture = SKTexture(rect: frameRect, in: texture)
            frames.append(frameTexture)
        }

        return frames
    }
}
