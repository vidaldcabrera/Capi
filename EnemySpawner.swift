// Tools/EnemySpawner.swift

import SpriteKit
import GameplayKit

class EnemySpawner {
    private weak var scene: SKScene?
    private var entityManager: SKEntityManager
    
    var bat: BatEntity?
    var mosquito: MosquitoEntity?
    var spider: SpiderEntity?
    
    init(scene: SKScene, entityManager: SKEntityManager) {
        self.scene = scene
        self.entityManager = entityManager
    }
    
    func spawnAll() {
        createSpider()
        createBat()
        createMosquito()
    }
    
    private func createSpider() {
        let texture = SKTexture(imageNamed: "hat-man-idle-1")
        let spider = SpiderEntity(texture: texture, position: CGPoint(x: -30, y: -30))
        self.spider = spider
        entityManager.add(entity: spider)


    }
    
    private func createBat() {
        bat = BatEntity(position: CGPoint(x: -100, y: 50))
        if let node = bat?.spriteNode {
            scene?.addChild(node)
        }
    }
    
    private func createMosquito() {
        mosquito = MosquitoEntity(position: CGPoint(x: 100, y: 50))
        if let node = mosquito?.spriteNode {
            scene?.addChild(node)
        }
    }
}
