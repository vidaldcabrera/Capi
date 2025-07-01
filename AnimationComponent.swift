import Foundation
import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    unowned let node: SKSpriteNode
    private let idleAction: SKAction
    private let runAction: SKAction
    private var isRunning = false
    private var animations: [String: SKAction] = [:]
    
    init(node: SKSpriteNode, idleAction: SKAction, runAction: SKAction) {
        self.node = node
        self.idleAction = idleAction
        self.runAction = runAction
        animations["idle"] = idleAction
        animations["run"] = runAction
        super.init()
        node.run(idleAction, withKey: "idle")
    }
    
    public func addAnimation(named name: String, action: SKAction) {
        animations[name] = action
    }
    
    public func playAnimation(named name: String) {
        guard let action = animations[name] else { return }
        node.removeAllActions()
        node.run(action, withKey: name)
        // opcional: ajustar isRunning se for relevante
    }
    
    public func playRun() {
        guard !isRunning else { return }
        node.removeAction(forKey: "idle")
        node.run(runAction, withKey: "run")
        isRunning = true
    }
    
    public func playIdle() {
        guard isRunning else { return }
        node.removeAction(forKey: "run")
        node.run(idleAction, withKey: "idle")
        isRunning = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
