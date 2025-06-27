//
//  HUDOverlay.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 18/06/25.
//


import SpriteKit
import GameplayKit

class HUDOverlay: SKNode {
    private var scoreLabel: SKLabelNode!

    override init() {
        super.init()
        self.isUserInteractionEnabled = true
    }

    func setupHUD(for sceneSize: CGSize) {
        let size = sceneSize
        let savedPositions = HUDOverlayPreview.loadLayoutFromUserDefaults()
        let verticalOffset: CGFloat = size.height * 0.25


        // ====== VIDAS ======
        for i in 0..<GameState.shared.lives {
            let heart = SKSpriteNode(imageNamed: "heart_static")
            heart.name = "heart"
            heart.position = CGPoint(
                x: -size.width/2 + 120 + CGFloat(i) * 40,
                y: size.height/2 - verticalOffset * 1.05
            )
            heart.zPosition = 100
            addChild(heart)
        }


        // ====== FRUTA E SCORE ======
        let fruitIcon = SKSpriteNode(imageNamed: "fruit_static")
        fruitIcon.position = CGPoint(x: -50, y: size.height/2 - verticalOffset * 1.05 )
        fruitIcon.zPosition = 100
        addChild(fruitIcon)

        scoreLabel = SKLabelNode(text: String(format: "%06d", GameState.shared.score))
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontSize = 32
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 0, y: size.height/2 - verticalOffset * 1.1)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)

        // ====== BOTÕES DE MOVIMENTO ======
        let defaultPositions: [String: CGPoint] = [
            "left": CGPoint(x: -size.width/2 + 50, y: -size.height/2 + 60),
            "right": CGPoint(x: -size.width/2 + 180, y: -size.height/2 + 60),
            "jump": CGPoint(x: size.width/2 - 120, y: -size.height/2 + 150),
            "action": CGPoint(x: size.width/2 - 200, y: -size.height/2 + 60)
        ]

        let buttonConfigs = [
            ("left", "left_button"),
            ("right", "right_button"),
            ("jump", "jump_button"),
            ("action", "action_button")
        ]

//        for (name, image) in buttonConfigs {
//            let button = SKSpriteNode(imageNamed: image)
//            button.name = name
//            button.position = savedPositions[name] ?? defaultPositions[name]!
//            button.zPosition = 100
//            addChild(button)
//        }
        
 
        let savedLayouts = HUDOverlayPreview.loadLayoutFromUserDefaults()

        for (name, image) in buttonConfigs {
            let button = SKSpriteNode(imageNamed: image)
            button.name = name

            if let layout = savedLayouts.first(where: { $0.name == name }) {
                button.position = layout.position(in: sceneSize)
            } else {
                button.position = defaultPositions[name]!
            }

            button.zPosition = 100
            addChild(button)
        }

        // ====== PAUSE E INVENTÁRIO ======
        let pauseButton = SKSpriteNode(imageNamed: "pause_button")
        pauseButton.name = "pause"
        pauseButton.position = CGPoint(x: size.width/2 - 120, y: size.height/2 - verticalOffset * 1.1)
        pauseButton.zPosition = 100
        addChild(pauseButton)

        let inventoryButton = SKSpriteNode(imageNamed: "inventory_button")
        inventoryButton.name = "inventory"
        inventoryButton.position = CGPoint(x: size.width/2 - 200, y: size.height/2 - verticalOffset * 1.1)
        inventoryButton.zPosition = 100
        addChild(inventoryButton)
        
//        updateScore(to: GameState.shared.score)
//        updateLives(to: GameState.shared.lives)

    }

    // ====== TOUCH: PAUSE BUTTON ======
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            if node.name == "pause" {
                VoiceOverManager.shared.speak("Jogo pausado")

                GameState.shared.playerPosition = self.scene?.childNode(withName: "player")?.position ?? .zero
                if let scene = self.scene {
                    let pauseScene = PauseScene(size: scene.size)
                    pauseScene.scaleMode = .aspectFill
                    scene.view?.presentScene(pauseScene, transition: .fade(withDuration: 0.3))
                }
            }
        }
    }

    // ====== ATUALIZAR SCORE ======
    func updateScore(to value: Int) {
        //scoreLabel.text = String(format: "%06d", value)
    }

    // ====== ATUALIZAR VIDAS ======
    func updateLives(to value: Int) {
        children.filter { $0.name == "heart" }.forEach { $0.removeFromParent() }
        guard let scene = self.scene else { return }
        let size = scene.size
        for i in 0..<value {
            let heart = SKSpriteNode(imageNamed: "heart_static")
            heart.name = "heart"
            heart.position = CGPoint(x: -size.width/2 + 20 + CGFloat(i) * 40, y: size.height/2 - 50)
            heart.zPosition = 100
            addChild(heart)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// =======HUD.PREVIEW======


// ButtonLayout.swift
import CoreGraphics

struct ButtonLayout: Codable {
    var name: String
    var xPercent: CGFloat
    var yPercent: CGFloat

    init(name: String, position: CGPoint, in size: CGSize) {
        self.name = name
        self.xPercent = (position.x + size.width / 2) / size.width
        self.yPercent = (position.y + size.height / 2) / size.height
    }

    func position(in size: CGSize) -> CGPoint {
        CGPoint(
            x: xPercent * size.width - size.width / 2,
            y: yPercent * size.height - size.height / 2
        )
    }
}


// HUDOverlayPreview.swift
import SpriteKit

class HUDOverlayPreview: SKNode {
    private var draggingNode: SKSpriteNode?
    private var buttonPositions: [String: CGPoint] = [:]
    private let panelSize: CGSize

    init(panelSize: CGSize) {
        self.panelSize = panelSize
        super.init()
        self.isUserInteractionEnabled = true

        let pw = panelSize.width
        let ph = panelSize.height
        let buttonScale = min(pw, ph) / 600

        let defaultPositions = [
            "left": CGPoint(x: -pw/2 + 50, y: -ph/2 + 60),
            "right": CGPoint(x: -pw/2 + 180, y: -ph/2 + 60),
            "jump": CGPoint(x: pw/2 - 120, y: -ph/2 + 150),
            "action": CGPoint(x: pw/2 - 200, y: -ph/2 + 60)
        ]

        let savedLayouts = HUDOverlayPreview.loadLayoutFromUserDefaults()

        for (name, defaultPosition) in defaultPositions {
            let button = SKSpriteNode(imageNamed: "\(name)_button")
            button.name = name
            button.setScale(buttonScale)

            if let layout = savedLayouts.first(where: { $0.name == name }) {
                button.position = layout.position(in: panelSize)
            } else {
                button.position = defaultPosition
            }

            button.zPosition = 1
            buttonPositions[name] = button.position
            addChild(button)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let node = atPoint(location) as? SKSpriteNode,
           let name = node.name,
           ["left", "right", "jump", "action"].contains(name) {
            draggingNode = node
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let node = draggingNode else { return }
        var location = touch.location(in: self)

        let halfWidth = panelSize.width / 2
        let halfHeight = panelSize.height / 2
        let padding: CGFloat = 40

        location.x = max(-halfWidth + padding, min(location.x, halfWidth - padding))
        location.y = max(-halfHeight + padding, min(location.y, halfHeight - padding))

        node.position = location

        if let name = node.name {
            buttonPositions[name] = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingNode = nil
        saveLayoutToUserDefaults()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingNode = nil
    }

    func saveLayoutToUserDefaults() {
        let layouts = buttonPositions.map {
            ButtonLayout(name: $0.key, position: $0.value, in: panelSize)
        }
        if let data = try? JSONEncoder().encode(layouts) {
            UserDefaults.standard.set(data, forKey: "buttonLayout")
        }
    }

    static func loadLayoutFromUserDefaults() -> [ButtonLayout] {
        guard let data = UserDefaults.standard.data(forKey: "buttonLayout"),
              let layouts = try? JSONDecoder().decode([ButtonLayout].self, from: data) else {
            return []
        }
        return layouts
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Uso no HUDOverlay.swift
// (exemplo dentro de setupHUD)

