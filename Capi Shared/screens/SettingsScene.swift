//
//  SettingsScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 17/06/25.
//

import Foundation
import SpriteKit
import GameplayKit

class SettingsScene: SKScene {
    var entityManager: SKEntityManager!
    
    override func didMove(to view: SKView) {
        self.entityManager = SKEntityManager(scene: self)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(imageNamed: "map")
        background.position = .zero
        background.size = view.frame.size
        background.setScale(proportionalScale(view: view, multiplier: 0.8))
        background.zPosition = -2
        addChild(background)

        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.position = .zero
        cloud.size = view.frame.size
        cloud.setScale(proportionalScale(view: view, multiplier: 0.8))
        cloud.zPosition = -1
        addChild(cloud)

        let box = SKSpriteNode(imageNamed: "box")
        box.position = .zero
        box.setScale(proportionalScale(view: view, multiplier: 0.7))
        box.xScale = 2.0
        box.zPosition = 5
        addChild(box)
        
        // Título
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "settings")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)

        
        // audio label
        let localizedAudio = LocalizationManager.shared.localizedString(forKey: "audio")
        let audioLabel = FontFactory.makeSubtitle(localizedAudio, at: CGPoint(x: frame.midX - 100, y: frame.midY + 80))
        audioLabel.zPosition = 15
        addChild(audioLabel)

        
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

        volumeAudioSlider.position = CGPoint(x: frame.midX + 70, y: frame.midY + 80)
        volumeAudioSlider.zPosition = 20
        addChild(volumeAudioSlider)

        // Atualiza o volume da música em tempo real
        volumeAudioSlider.onValueChanged = { newVolume in
            MusicManager.shared.setVolume(to: newVolume)
            UserDefaults.standard.set(Float(newVolume), forKey: "musicVolume")
        }
        
        
        // Music Label
        let localizedMusic = LocalizationManager.shared.localizedString(forKey: "music")
        let musicLabel = FontFactory.makeSubtitle(localizedMusic, at: CGPoint(x: frame.midX - 100, y: frame.midY + 10))
        musicLabel.zPosition = 15
        addChild(musicLabel)

        
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

        volumeMusicSlider.position = CGPoint(x: frame.midX + 70, y: frame.midY + 5
        )
        volumeMusicSlider.zPosition = 20
        addChild(volumeMusicSlider)

        // Atualiza o volume da música em tempo real
        volumeMusicSlider.onValueChanged = { newVolume in
            MusicManager.shared.setVolume(to: newVolume)
            UserDefaults.standard.set(Float(newVolume), forKey: "musicVolume")
        }


        //  language Button
        let languageButton = ButtonEntity(
            imageNamed: "ButtonBoxUnselected",
            position: CGPoint(x: frame.midX, y: frame.midY - 80),
            name: "language_button",
            title: LocalizationManager.shared.localizedString(forKey: "language"),
            action: {
                let scene = LanguageScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
            }
        )

        entityManager.add(entity: languageButton)

        if let node = languageButton.component(ofType: GKSKNodeComponent.self)?.node {
            node.setScale(0.8)
            node.zPosition = 30
            if node.parent == nil {   // <-- EVITA o erro
                addChild(node)
            }

            // Adiciona o texto acima do botão
            let label = FontFactory.makeButton(LocalizationManager.shared.localizedString(forKey: "language"), at: .zero)
            label.zPosition = node.zPosition + 1
            if label.parent == nil {
                node.addChild(label)
            }
        }


        
        
        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "back"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location).sorted { $0.zPosition > $1.zPosition }

        for node in touchedNodes {
            guard let nodeName = node.name else { continue }
            if node.name == "back" {
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "back"))
                let scene = GameScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
                return
            } else if node.name == "language_button" {
                handleButtonTouch(named: nodeName, at: location)
                let scene = LanguageScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
                return
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
