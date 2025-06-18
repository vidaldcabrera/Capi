import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    
    var direction: CGFloat = 1
    let speed: CGFloat = 0.0005
    let offset: CGFloat = 100
    var initialY: CGFloat?

    override func update(deltaTime seconds: TimeInterval) {
    
    }

    func spiderVerticalMovement(deltaTime seconds: TimeInterval){
        guard let renderComponent = entity?.component(ofType: RenderComponent.self), let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }

                let node = renderComponent.node

                if initialY == nil {
                    initialY = node.position.y
                }

                guard let baseY = initialY else { return }

                node.position.y += direction * speed * CGFloat(seconds)

                if node.position.y >= baseY + offset {
                    node.position.y = baseY + offset
                    animationComponent.runAnimation(named: "descendo")
                    direction = -1
                } else if node.position.y <= baseY - offset {
                    node.position.y = baseY - offset
                    animationComponent.runAnimation(named: "subindo")
                    direction = 1
                }
        }
    
    func spiderIdleMovement(deltaTime seconds: TimeInterval){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "parado")
    }
    
    func spiderAttackMovement(deltaTime seconds: TimeInterval){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "ataque")
    }
    
    func spiderDeadMovement(deltaTime seconds: TimeInterval){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "morte")
    }
}

