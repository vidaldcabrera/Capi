//
//  FlyingState.swift
//  Capi iOS
//
//  Created by Aluno 23 on 16/06/25.
//

import Foundation
import SpriteKit
import GameplayKit

class BatFlyingState: GKState{
    
    unowned let bat: BatEntity
        let leftLimit: CGFloat
        let rightLimit: CGFloat
        var goingRight = true
        let speed: CGFloat = 80
    
        var timeElapsed: TimeInterval = 0
        let amplitude: CGFloat = 20  // Altura do zigzag
        let frequency: CGFloat = 2   // Quantidade de oscilações por segundo

        init(bat: BatEntity, leftLimit: CGFloat, rightLimit: CGFloat) {
            self.bat = bat
            self.leftLimit = leftLimit
            self.rightLimit = rightLimit
            super.init()
        }
    override func didEnter(from previousState: GKState?) {
        // Para garantir que não empilhe ações
        bat.spriteNode.removeAllActions()

        // Animação de voo
        let flyAnimation = SKAction.animate(with: bat.flyFrames, timePerFrame: 0.1)
        let repeatFly = SKAction.repeatForever(flyAnimation)
        bat.spriteNode.run(repeatFly, withKey: "FlyAnimation")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        timeElapsed += seconds
        
        let direction: CGFloat = goingRight ? 1 : -1
        bat.spriteNode.position.x += direction * speed * CGFloat(seconds)
        
        bat.spriteNode.xScale = goingRight ? -1.0 : 1.0
        
        
        // Movimento vertical (zigzag usando seno)
        let baseY = bat.baseYPosition
        bat.spriteNode.position.y = baseY + amplitude * sin(CGFloat(timeElapsed) * frequency * .pi * 2)

            
        if bat.spriteNode.position.x >= rightLimit {
                goingRight = false
        } else if bat.spriteNode.position.x <= leftLimit {
                goingRight = true
            }
        }

        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == BatAttackingState.self || stateClass == BatDyingState.self
        }
    }
