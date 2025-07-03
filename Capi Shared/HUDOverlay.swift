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
        fruitIcon.position = CGPoint(x: -50, y: size.height/2 - verticalOffset * 1.05)
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

        let savedLayouts = HUDOverlayPreview.loadLayoutFromUserDefaults()

        for (name, image) in buttonConfigs {
            let button = SKSpriteNode(imageNamed: image)
            button.name = name

            if let layout = savedLayouts.first(where: { $0.name == name }) {
                button.position = layout.position(in: sceneSize)
                button.setScale(layout.scale) // <- Corrigido aqui
            } else {
                button.position = defaultPositions[name]!
                button.setScale(1.0)
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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            if node.name == "pause" {
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "pause"))

                GameState.shared.playerPosition = self.scene?.childNode(withName: "player")?.position ?? .zero
                if let scene = self.scene {
                    let pauseScene = PauseScene(size: scene.size)
                    pauseScene.scaleMode = .aspectFill
                    scene.view?.presentScene(pauseScene, transition: .fade(withDuration: 0.3))
                }
            }
            
            if node.name == "inventory" {
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "inventory"))

                GameState.shared.playerPosition = self.scene?.childNode(withName: "player")?.position ?? .zero
                if let scene = self.scene {
                    let inventoryScene = InventoryScene(size: scene.size)
                    inventoryScene.scaleMode = .aspectFill
                    scene.view?.presentScene(inventoryScene, transition: .fade(withDuration: 0.3))
                }
            }
        }
    }

    func updateScore(to value: Int) {
        scoreLabel.text = String(format: "%06d", value)
    }

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
    var scale: CGFloat  // <-- novo campo

    init(name: String, position: CGPoint, in size: CGSize, scale: CGFloat = 1.0) {
        self.name = name
        self.xPercent = (position.x + size.width / 2) / size.width
        self.yPercent = (position.y + size.height / 2) / size.height * 0.7
        self.scale = scale
    }

    func position(in size: CGSize) -> CGPoint {
        CGPoint(
            x: xPercent * size.width - size.width / 2,
            y: yPercent * size.height - size.height * 0.7 / 2
        )
    }
}

// HUDOverlayPreview.swift
import SpriteKit

class HUDOverlayPreview: SKNode {
    private var draggingNode: SKSpriteNode?
    private var buttonPositions: [String: CGPoint] = [:]
    private var buttonScales: [String: CGFloat] = [:]
    private let panelSize: CGSize
    private let previewBaseScale: CGFloat

    init(panelSize: CGSize) {
        self.panelSize = panelSize
        self.previewBaseScale = min(panelSize.width, panelSize.height) / 600
        super.init()
        self.isUserInteractionEnabled = true

        let defaultPositions = [
            "left": CGPoint(x: -panelSize.width/2 + 50, y: -panelSize.height/2 + 60),
            "right": CGPoint(x: -panelSize.width/2 + 180, y: -panelSize.height/2 + 60),
            "jump": CGPoint(x: panelSize.width/2 - 120, y: -panelSize.height/2 + 150),
            "action": CGPoint(x: panelSize.width/2 - 200, y: -panelSize.height/2 + 60)
        ]

        let savedLayouts = HUDOverlayPreview.loadLayoutFromUserDefaults()

        for (name, defaultPosition) in defaultPositions {
            let button = SKSpriteNode(imageNamed: "\(name)_button")
            button.name = name

            if let layout = savedLayouts.first(where: { $0.name == name }) {
                button.position = layout.position(in: panelSize)
                let realScale = layout.scale * previewBaseScale
                button.setScale(realScale)
                buttonScales[name] = realScale
            } else {
                button.position = defaultPosition
                button.setScale(previewBaseScale)
                buttonScales[name] = previewBaseScale
            }

            button.zPosition = 1
            buttonPositions[name] = button.position
            addChild(button)
        }

        let box = SKSpriteNode(imageNamed: "control_box")
        box.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        box.zPosition = -100
        addChild(box)
        
        let iconRight = SKSpriteNode(imageNamed: "right_button")
        iconRight.position = CGPoint(x: frame.midX - 525, y: frame.midY + 130)
        iconRight.setScale(0.6)
        iconRight.zPosition = 100
        addChild(iconRight)
        
        let iconLeft = SKSpriteNode(imageNamed: "left_button")
        iconLeft.position = CGPoint(x: frame.midX - 525, y: frame.midY - 40)
        iconLeft.setScale(0.6)
        iconLeft.zPosition = 100
        addChild(iconLeft)

        let iconJump = SKSpriteNode(imageNamed: "jump_button")
        iconJump .position = CGPoint(x: frame.midX + 525, y: frame.midY + 130)
        iconJump .setScale(0.6)
        iconJump .zPosition = 100
        addChild(iconJump)

        let iconAction = SKSpriteNode(imageNamed: "action_button")
        iconAction .position = CGPoint(x: frame.midX + 525, y: frame.midY - 40)
        iconAction .setScale(0.6)
        iconAction .zPosition = 100
        addChild(iconAction)


        // SLIDERS

        let sliderConfigs: [(name: String, pos: CGPoint)] = [
            ("right", CGPoint(x: frame.midX - 525, y: frame.midY + 60)),
            ("left", CGPoint(x: frame.midX - 525, y: frame.midY - 110)),
            ("jump", CGPoint(x: frame.midX + 525, y: frame.midY + 60)),
            ("action", CGPoint(x: frame.midX + 525, y: frame.midY - 110))
        ]

        
        
        
        
        for (name, pos) in sliderConfigs {
            let initialScale = buttonScales[name] ?? previewBaseScale
            var previousValue = initialScale

            let slider = CustomSlider(trackImage: "bar", thumbImage: "thumb", min: 0.5, max: 2.0, initial: initialScale)
            slider.position = pos

            slider.onValueChanged = { newValue in
                guard let button = self.childNode(withName: name) as? SKSpriteNode else { return }

                // Atualiza visualmente o botão da preview
                button.setScale(newValue)

                // Atualiza escala interna
                self.buttonScales[name] = newValue

                // === Fator de escala ===
                let scaleFactor = newValue / previousValue
                previousValue = newValue

                // Aplica a mesma escala multiplicativa no botão do HUD, se existir
                if let hud = self.scene?.childNode(withName: "HUD") as? HUDOverlay,
                   let hudButton = hud.childNode(withName: name) as? SKSpriteNode {
                    let currentHUDScale = hudButton.xScale // xScale = yScale aqui
                    hudButton.setScale(currentHUDScale * scaleFactor)
                    
                }
                self.saveLayoutToUserDefaults()

            }

            addChild(slider)
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
        let paddingX: CGFloat = 40
        let paddingY: CGFloat = 40

        location.x = max(-halfWidth + paddingX, min(location.x, halfWidth - paddingX))
        location.y = max(-halfHeight + paddingY, min(location.y, halfHeight - paddingY))

        node.position = location

        if let name = node.name {
            buttonPositions[name] = location
        }
    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        draggingNode = nil
//        saveLayoutToUserDefaults()
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//
//        if let node = atPoint(location) as? SKSpriteNode,
//           let name = node.name,
//           ["left", "right", "jump", "action"].contains(name) {
//            let current = buttonScales[name] ?? previewBaseScale
//            let newScale = current < previewBaseScale * 1.5 ? current + 0.1 : previewBaseScale
//            node.setScale(newScale)
//            buttonScales[name] = newScale
//            buttonPositions[name] = node.position
//        }

        draggingNode = nil
        saveLayoutToUserDefaults()
    }


    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingNode = nil
    }

    func saveLayoutToUserDefaults() {
        let layouts = buttonPositions.map { (name, position) -> ButtonLayout in
            let realScale = buttonScales[name] ?? previewBaseScale
            let relativeScale = realScale / previewBaseScale
            return ButtonLayout(name: name, position: position, in: panelSize, scale: relativeScale)
        }

        if let data = try? JSONEncoder().encode(layouts) {
            UserDefaults.standard.set(data, forKey: "buttonLayout")
            print("✅ Layout salvo com sucesso:", layouts)
        } else {
            print("❌ Erro ao salvar layout.")
        }
    }

    static func loadLayoutFromUserDefaults() -> [ButtonLayout] {
        guard let data = UserDefaults.standard.data(forKey: "buttonLayout"),
              let layouts = try? JSONDecoder().decode([ButtonLayout].self, from: data) else {
            return []
        }
        print("📦 Layout carregado:", layouts)
        return layouts
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
