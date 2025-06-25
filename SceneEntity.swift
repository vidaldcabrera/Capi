

//
//  SceneEntity.swift
//  Capi iOS
//

import Foundation
import GameplayKit
import SpriteKit

class SceneEntity: GKEntity {
    init(named: String, entityManager: SKEntityManager) {
        super.init()

        if let sceneNode = SKReferenceNode(fileNamed: named) {
            self.addComponent(GKSKNodeComponent(node: sceneNode))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//class SceneEntity: GKEntity {
//    init(named: String, entityManager: SKEntityManager) {
//        super.init()
//
//        if let sceneNode = SKReferenceNode(fileNamed: named) {
//            sceneNode.entityManager = entityManager
//            sceneNode.scaleMode = .aspectFill
//            entityManager.scene.addChild(sceneNode) // adiciona o nó da subscene
//            self.addComponent(GKSKNodeComponent(node: sceneNode))
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}



//
//  InitialScene.swift
//  Capi iOS
//

//class InitialScene: SKScene {
//    var entities: [GKEntity] = []
//    var entityManager: SKEntityManager?
//
//    override func didMove(to view: SKView) {
//        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
//            addChild(node)
//        let buttonStart = ButtonNode(sprite: .init(imageNamed: "start_button")) {
//            print("comecar")
//        }
//        buttonStart.zPosition = 10
//        addChild(buttonStart)

//        let startButton = ButtonNode(sprite: .init(color: .blue, size: .init(width: 300, height: 100)), label: .init(text:".")){
//            print("Botão pressionado!")
//        }
//        addChild(startButton)

        // Use entityManager se estiver disponível


//    }
//}
    

//    func addEntity(_ entity: GKEntity) {
//        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node {
//            addChild(node)
//            let buttonStart = ButtonNode(sprite: .init(imageNamed: "start_button")) {
//                print("comecar")
//            }
//            buttonStart.zPosition = 10
//            addChild(buttonStart)
//        }
//        entities.append(entity)
//    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for entity in entities {
//            if let buttonComponent = entity.component(ofType: ButtonComponent.self) {
//                buttonComponent.touchesBegan(touches, in: self)
//            }
//        }
//    }
//}
