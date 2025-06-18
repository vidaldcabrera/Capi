import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    
    var direction: CGFloat = 1
    let speed: CGFloat = 3
    let offset: CGFloat = 100
    var initialY: CGFloat?
    
    
    
    func spiderVerticalMovement() {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self),
              let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }

        let node = renderComponent.node

        if initialY == nil {
            initialY = node.position.y
        }

        guard let baseY = initialY else { return }

        // Troca a animação antes de começar a movimentar
        let currentAnimation = direction > 0 ? "subindo" : "descendo"
        animationComponent.runAnimation(named: currentAnimation)

        // Move
        node.position.y += direction * speed

        // Verifica limites e inverte direção
        if node.position.y >= baseY + offset {
            node.position.y = baseY + offset
            direction = -1
        } else if node.position.y <= baseY - offset {
            node.position.y = baseY - offset
            direction = 1
        }
    }

    
    func spiderIdleMovement(){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "parado")
    }
    
    func spiderAttackMovement(){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "ataque")
    }
    
    func spiderDeadMovement(){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "morte")
    }
}

