//  GameScene.swift
//  Capi Shared
//
//  Created by Aluno 48 on 26/05/25.

import SpriteKit
import GameplayKit
import Foundation

func proportionalScale(view: SKView, baseWidth: CGFloat = 390.0, multiplier: CGFloat) -> CGFloat {
    return (view.frame.width / baseWidth) * multiplier
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var entityManager = SKEntityManager()
    var mosquito: MosquitoEntity?
    var entities: [GKEntity] = []
    var bat: BatEntity?
    private var lastTapTime: TimeInterval = 0
    private let doubleTapMaxDelay: TimeInterval = 0.3

    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            fatalError("Failed to load GameScene.sks")
        }
        scene.scaleMode = .aspectFill
        return scene
    }

    func setUpScene(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black

        createBackground()
        createCloud()
        createTitle()
        initButtons()
        createSpider()
        createBat()
        createMosquito()

    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        handleSpiderContact(contact)
        handleBatContact(contact)
        handleMosquitoContact(contact)
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setUpScene(view)
    }
    
    private var lastUpdateTime: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        
        for entity in entities {
            entity.update(deltaTime: currentTime)
        }
        var deltaTime = currentTime - lastUpdateTime
        if lastUpdateTime == 0 {
            deltaTime = 0
        }
        lastUpdateTime = currentTime
        bat?.batStateMachine.update(deltaTime: deltaTime)
        mosquito?.mosquitoStateMachine.update(deltaTime: deltaTime)
    }
}

extension GameScene {

    func handleBatContact(_ contact: SKPhysicsContact){
        
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
        
        // Checa: Player tocando o morcego
        if firstBody.categoryBitMask == PhysicsCategory.player &&
            secondBody.categoryBitMask == PhysicsCategory.bat {
            
            if let batEntity = bat {
                batEntity.batStateMachine.enter(BatAttackingState.self)
            }
        }
        
    }
    
    func handleSpiderContact(_ contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        var spiderNode: SKNode?
        var otherNode: SKNode?
        
        
        guard let nodeA = bodyA.node, let nodeB = bodyB.node else {
            return
        }
        
        
        if nodeA.name == "spider" {
            spiderNode = nodeA
            otherNode = nodeB
        } else if nodeB.name == "spider" {
            spiderNode = nodeB
            otherNode = nodeA
        } else {
            return // nenhum dos dois é aranha
        }
    
        
        guard let spiderEntity = spiderNode?.entity as? SpiderEntity else {
            return
        }
        
        
        if let stateMachineComponent = spiderEntity.component(ofType: StateMachineComponent.self) {
            if otherNode?.name == "player" {
                if !(stateMachineComponent.stateMachine.currentState is SpiderAttackState) {
                    print("colidiu")
                    stateMachineComponent.stateMachine.enter(SpiderAttackState.self)
                }
            } else if otherNode?.name == "playerAttack" {
                print("atacoueste")
                stateMachineComponent.stateMachine.enter(SpiderDeadState.self)
            }
        }
    }

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
    
    
    func createSpider() {
        let spiderTexture = SKTexture(imageNamed: "hat-man-idle-1")
        let spider = SpiderEntity(texture: spiderTexture, position: CGPoint(x: -30, y: -30))
        
        if let node = spider.component(ofType: RenderComponent.self)?.node {
            node.name = "spider"
            node.entity = spider
            addChild(node)
        }
        entities.append(spider)
    }

    func createBat() {
        // Cria o mosquito e adiciona na cena
        bat = BatEntity(position: CGPoint(x: -100, y: 50))
        
        if let batNode = bat?.spriteNode {
            addChild(batNode)
        }
    }

    func createMosquito(){
        // Cria o mosquito e adiciona na cena
        mosquito = MosquitoEntity(position: CGPoint(x: 100, y: 50))
        
        if let mosquitoNode = mosquito?.spriteNode {
            addChild(mosquitoNode)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for entity in entityManager.entities {
            if let button = entity.component(ofType: ButtonComponent.self) {
                button.handleTouch(location: location)
            }
        }
    }

    func createBackground() {

        let background = SKSpriteNode(imageNamed: "map")
        background.position = .zero
        background.size = view.frame.size
        background.setScale(proportionalScale(view: view, multiplier: 0.8))
        background.zPosition = -2
        addChild(background)

    }

    func createCloud(){
        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.position = .zero
        cloud.size = view.frame.size
        cloud.setScale(proportionalScale(view: view, multiplier: 0.8))
        cloud.zPosition = -1
        addChild(cloud)
    }

    func createTitle(){
        let title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: 0, y: view.frame.height * 0.45)
        title.setScale(proportionalScale(view: view, multiplier: 0.7))
        title.zPosition = 0
        addChild(title)
    }

    func initButtons(){
        let buttons: [(String, CGFloat, () -> Void)] = [
            ("start_button", 0.1, {
                let scene = LevelScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("options_button", -0.14, {
                let scene = SettingsScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("difficulty_button", -0.37, {
                let scene = DifficultyScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("credits_button", -0.6, {
                let scene = CreditsScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            })
        ]


        for (name, relativeY, action) in buttons {
            let button = ButtonEntity(
                imageNamed: name,
                position: CGPoint(x: 0, y: view.frame.height * relativeY),
                name: name,
                action: action
            )
            entityManager.add(entity: button)
            if let node = button.component(ofType: GKSKNodeComponent.self)?.node {
                node.setScale(proportionalScale(view: view, multiplier: 0.4))
                addChild(node)
            }
        }
    }
}
