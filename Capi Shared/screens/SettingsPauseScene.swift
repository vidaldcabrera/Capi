import Foundation
import SpriteKit
import GameplayKit

class SettingsPauseScene: SKScene {
    var entityManager: SKEntityManager!
    
    override func didMove(to view: SKView) {
        self.entityManager = SKEntityManager(scene: self)
        backgroundColor = .clear
        self.isUserInteractionEnabled = true

        // Fundo escuro transparente
        let overlay = SKSpriteNode(color: UIColor.clear.withAlphaComponent(0.7), size: size)
        overlay.position = CGPoint(x: frame.midX, y: frame.midY)
        overlay.zPosition = 12
        addChild(overlay)

        // Painel de Configurações
        let box = SKSpriteNode(imageNamed: "box")
        box.position = CGPoint(x: frame.midX, y: frame.midY)
        box.setScale(1.5)
        box.zPosition = 14
        addChild(box)

        // Título
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "settings")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)
        
        // subtitulo
                                 
        let localizedSubTitle1 = LocalizationManager.shared.localizedString(forKey: "audio")
        let subTitleLabel1 = FontFactory.makeSubtitle(localizedSubTitle1, at: CGPoint(x: frame.midX - 100, y: frame.midY + 75))
        subTitleLabel1.zPosition = 15
        addChild(subTitleLabel1)
                                 
        
        // Recupera o volume salvo (ou usa 0.5 como padrão)
        let savedAudioVolume = UserDefaults.standard.float(forKey: "musicVolume")
        let initialAudioVolume = savedAudioVolume == 0 ? 0.5 : savedAudioVolume

        let volumeAudioSlider = CustomSlider(
            trackImage: "bar",
            thumbImage: "thumb",
            min: 0,
            max: 1,
            initial: CGFloat(initialAudioVolume)
        )

        volumeAudioSlider.position = CGPoint(x: frame.midX + 70, y: frame.midY + 70)
        volumeAudioSlider.zPosition = 20
        addChild(volumeAudioSlider)

        // Atualiza o volume da música em tempo real
        volumeAudioSlider.onValueChanged = { newVolume in
            MusicManager.shared.setVolume(to: newVolume)
            UserDefaults.standard.set(Float(newVolume), forKey: "musicVolume")
        }
        
        
        // subtitulo
        let localizedSubTitle2 = LocalizationManager.shared.localizedString(forKey: "music")
        let subTitleLabel2 = FontFactory.makeSubtitle(localizedSubTitle2, at: CGPoint(x: frame.midX - 100, y: frame.midY))
        subTitleLabel2.zPosition = 15
        addChild(subTitleLabel2)
        
        
        
        // Recupera o volume salvo (ou usa 0.5 como padrão)
        let savedMusicVolume = UserDefaults.standard.float(forKey: "musicVolume")
        let initialMusicVolume = savedMusicVolume == 0 ? 0.5 : savedMusicVolume

        let volumeMusicSlider = CustomSlider(
            trackImage: "bar",
            thumbImage: "thumb",
            min: 0,
            max: 1,
            initial: CGFloat(initialMusicVolume)
        )

        volumeMusicSlider.position = CGPoint(x: frame.midX + 70, y: frame.midY - 5
        )
        volumeMusicSlider.zPosition = 20
        addChild(volumeMusicSlider)

        // Atualiza o volume da música em tempo real
        volumeMusicSlider.onValueChanged = { newVolume in
            MusicManager.shared.setVolume(to: newVolume)
            UserDefaults.standard.set(Float(newVolume), forKey: "musicVolume")
        }
        
        
        
        
        let buttons: [(String, String, CGFloat)] = [
            ("ButtonBoxUnselected", "controls", -80),
            ("ButtonBoxUnselected", "accessibility", 100)
        ]

        for (nomeImage, name, relativeY) in buttons {
            let button = ButtonEntity(
                imageNamed: nomeImage,
                position: CGPoint(x: frame.midX + relativeY, y: frame.midY - 80),
                name: name,
                title: LocalizationManager.shared.localizedString(forKey: name),
                action: {} // vazio, pois o toque é tratado no `touchesBegan`
            )
            entityManager.add(entity: button)
            if let node = button.component(ofType: GKSKNodeComponent.self)?.node {
                node.setScale(proportionalScale(view: view, multiplier: 0.4))
                if node.parent == nil {
                    addChild(node)
                }
            }
        }
        
        
        
        
        // Back Button (voltar para PauseScene)
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.name = "back"
        backButton.position = CGPoint(x: frame.midX + 10, y: frame.midY - 150)
        backButton.setScale(0.8)
        backButton.zPosition = 15
        addChild(backButton)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            guard let nodeName = node.name else { continue }
            switch node.name {
            case "back":
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "back"))
                let pauseScene = PauseScene(size: self.size)
                pauseScene.scaleMode = .aspectFill
                view?.presentScene(pauseScene, transition: .fade(withDuration: 0.3))
            case "controls":
                handleButtonTouch(named: nodeName, at: location)
                let controlsScene = ControlSettingsScene(size: self.size)
                controlsScene.scaleMode = .aspectFill
                view?.presentScene(controlsScene, transition: .fade(withDuration: 0.5))
                break
            case "accessibility":
                handleButtonTouch(named: nodeName, at: location)
                let accessibilityScene = AccessibilityScene(size: self.size)
                accessibilityScene.scaleMode = .aspectFill
                view?.presentScene(accessibilityScene, transition: .fade(withDuration: 0.5))
                break
            default:
                break
            }
        }
    }
    func handleButtonTouch(named nodeName: String, at location: CGPoint) {
        if let entity = entityManager.entities.first(where: {
            $0.component(ofType: GKSKNodeComponent.self)?.node.name == nodeName
        }),
        let button = entity.component(ofType: ButtonComponent.self) {
            button.handleTouch(location: location)
        }
    }
}
