import Foundation
import SpriteKit
import GameplayKit


class StateMachineComponent: GKComponent {
    let stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        self.stateMachine = GKStateMachine(states: states)
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
