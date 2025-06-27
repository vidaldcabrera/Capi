import Foundation
import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    
    let node: SKSpriteNode
    var animations: [String: SKAction] = [:]
    var currentAnimationKey: String?
    var idleAction: SKAction
    var runAction: SKAction
    var node: SKNode?
    var isRun = false
    
    
    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }
    
    func addAnimation(named name: String, action: SKAction) {
        animations[name] = action
    }
    
    func runAnimation(named name: String) {
        guard currentAnimationKey != name else { return }
        guard let action = animations[name] else { return }
        
        node.removeAllActions()
        node.run(action)
        currentAnimationKey = name
    }
    
    init(idleAction: SKAction, runAction: SKAction) {
        self.idleAction = idleAction
        self.runAction = runAction
        super.init()
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
        playIdle()
    }
    
    public func playIdle() {
        node?.run(idleAction)
        isRun = false
    }
    
    public func playRun() {
        if !isRun {
            node?.run(runAction)
        }
        isRun = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
