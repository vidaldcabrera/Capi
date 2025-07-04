import Foundation
import SpriteKit
import GameplayKit

enum Direction: CGFloat {
    case right = 1, left = -1, none = 0
}

class MovementComponent: GKComponent {
    /// Direção atual de movimento
    private(set) var direction: Direction = .none
    /// Velocidade de movimento
    private let speed: CGFloat
    init(speed: CGFloat = 3) {
        self.speed = speed
        super.init()
    }
    /// Deslocamento para movimento vertical de aranha
    private let offset: CGFloat = 100
    /// Posição Y inicial para movimento vertical
    private var initialY: CGFloat?

    private var animationComp: AnimationComponent? {
        entity?.component(ofType: AnimationComponent.self)
    }
    /// Nó de renderização (sprite ou outro) da entidade
    private var renderNode: SKNode? {
        entity?.component(ofType: GKSKNodeComponent.self)?.node
    }

    /// Altera a direção de movimento horizontal
    func change(direction newDirection: Direction) {
        guard direction != newDirection else { return }
        direction = newDirection
        if newDirection == .none {
            animationComp?.playIdle()
        } else {
            animationComp?.playRun()
        }
    }

    /// Atualiza posição horizontal
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = renderNode, direction != .none else { return }
        print("Movendo jogador: \(direction)")
        node.position.x += direction.rawValue * speed
        // Ajusta escala para refletir direção
  //      node.xScale = abs(node.xScale) * direction.rawValue
        
        switch direction {
            case .left:
                node.position.x -= speed
                node.xScale = -1
            case .right:
                node.position.x += speed
                node.xScale = 1
            case .none:
                break
            }
    }

    /// Movimentação vertical oscilante (por exemplo, aranhas)
    func spiderVerticalMovement() {
        guard let node = renderNode else { return }
        if initialY == nil { initialY = node.position.y }
        let baseY = initialY!
        node.position.y += direction.rawValue * speed
        if node.position.y >= baseY + offset {
            direction = .left
        } else if node.position.y <= baseY - offset {
            direction = .right
        }
    }

    /// Executa pulo simples, verificando se está no chão
    func jump() {
        guard let body = renderNode?.physicsBody else { return }
        let isOnGround = abs(body.velocity.dy) < 1.0
        if isOnGround {
            // Impulso vertical
            body.applyImpulse(CGVector(dx: 0, dy: 30))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovementComponent {
  /// Chamada quando entra no estado “idle” da aranha
  func spiderIdleMovement() {
    spiderVerticalMovement()
  }

  /// Chamada quando entra no estado “attack” da aranha
  func spiderAttackMovement() {
    spiderVerticalMovement()
  }

  /// Chamada quando a aranha morre
  func spiderDeadMovement() {
    // por exemplo, para e remove as ações de oscilação
    renderNode?.removeAllActions()
    // ou qualquer outra limpeza que seja necessária
  }
}
