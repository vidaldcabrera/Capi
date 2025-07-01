import Foundation
import SpriteKit
import GameplayKit

class BatEntity: GKEntity {
    /// Posição vertical base para voo
    let baseYPosition: CGFloat
    /// Nó de sprite do morcego
    let spriteNode: SKSpriteNode
    /// Máquina de estados do morcego
    var batStateMachine: GKStateMachine!

    /// Frames de animação
    let flyFrames: [SKTexture]
    let attackFrames: [SKTexture]
    let deathFrames: [SKTexture]

    init(position: CGPoint) {
        // Configura propriedades antes de super.init
        self.baseYPosition = position.y
        self.flyFrames    = BatEntity.loadFrames(from: "BatFlying", frameCount: 8)
        self.attackFrames = BatEntity.loadFrames(from: "BatAttack", frameCount: 11)
        self.deathFrames  = BatEntity.loadFrames(from: "BatDeath", frameCount: 12)

        // Cria o sprite com o primeiro frame de voo
        self.spriteNode = SKSpriteNode(texture: flyFrames.first)
        self.spriteNode.position = position
        self.spriteNode.name     = "bat"

        super.init()

        // Configuração física
        let physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        physicsBody.isDynamic             = false
        physicsBody.affectedByGravity     = false
        physicsBody.categoryBitMask       = PhysicsCategory.bat
        physicsBody.contactTestBitMask    = PhysicsCategory.player
        physicsBody.collisionBitMask      = PhysicsCategory.ground
        spriteNode.physicsBody            = physicsBody

        // Inicializa estados
        let flyState    = BatFlyingState(bat: self, leftLimit: position.x - 50, rightLimit: position.x + 50)
        let attackState = BatAttackingState(bat: self)
        let deathState  = BatDyingState(bat: self)
        batStateMachine = GKStateMachine(states: [flyState, attackState, deathState])
        batStateMachine.enter(BatFlyingState.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Carrega frames cortando spritesheet horizontal
    private static func loadFrames(from imageName: String, frameCount: Int) -> [SKTexture] {
        let texture    = SKTexture(imageNamed: imageName)
        let frameWidth = 1.0 / CGFloat(frameCount)
        return (0..<frameCount).map { index in
            let rect = CGRect(x: CGFloat(index) * frameWidth,
                              y: 0,
                              width: frameWidth,
                              height: 1.0)
            return SKTexture(rect: rect, in: texture)
        }
    }
}
