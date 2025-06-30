//
//  SettingsPauseScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 23/06/25.
//

import Foundation
import SpriteKit

class SettingsPauseScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        self.isUserInteractionEnabled = true

        // Fundo escuro transparente
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: size)
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
        let title = SKSpriteNode(imageNamed: "settings_txt")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        title.zPosition = 15
        addChild(title)
        
        // Texto "audio"
        let audio = SKSpriteNode(imageNamed: "audio_txt")
        audio.position = CGPoint(x: frame.midX - 100, y: frame.midY + 75
        )
        audio.zPosition = 15
        addChild(audio)
        
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

        // Music Label
        let music = SKSpriteNode(imageNamed: "music_txt")
        music.position = CGPoint(x: frame.midX - 100, y: frame.midY)
        music.zPosition = 15
        addChild(music)
        
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

        // Controls Button
        let controlsButton = SKSpriteNode(imageNamed: "controls_button")
        controlsButton.name = "controls"
        controlsButton.position = CGPoint(x: frame.midX - 80, y: frame.midY - 80)
        controlsButton.setScale(0.8)
        controlsButton.zPosition = 15
        addChild(controlsButton)

        // Accessibility Button
        let accessibilityButton = SKSpriteNode(imageNamed: "accessibility_button")
        accessibilityButton.name = "accessibility"
        accessibilityButton.position = CGPoint(x: frame.midX + 100, y: frame.midY - 80)
        accessibilityButton.setScale(0.8)
        accessibilityButton.zPosition = 15
        addChild(accessibilityButton)

        // Back Button (voltar para PauseScene)
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.name = "back"
        backButton.position = CGPoint(x: frame.midX + 10, y: frame.midY - 150)
        backButton.setScale(0.8)
        backButton.zPosition = 15
        addChild(backButton)

//        // Sliders são simulados por sprites, por enquanto
//        let audioBar = SKSpriteNode(imageNamed: "slider")
//        audioBar.position = CGPoint(x: frame.midX + 80, y: frame.midY + 60)
//        audioBar.setScale(0.8)
//        audioBar.zPosition = 15
//        addChild(audioBar)
//
//        let musicBar = SKSpriteNode(imageNamed: "slider")
//        musicBar.position = CGPoint(x: frame.midX + 80, y: frame.midY)
//        musicBar.setScale(0.8)
//        musicBar.zPosition = 15
//        addChild(musicBar)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            switch node.name {
            case "back":
                let pauseScene = PauseScene(size: self.size)
                pauseScene.scaleMode = .aspectFill
                view?.presentScene(pauseScene, transition: .fade(withDuration: 0.3))
            case "controls":
                let controlsScene = ControlSettingsScene(size: self.size)
                controlsScene.scaleMode = .aspectFill
                view?.presentScene(controlsScene, transition: .fade(withDuration: 0.5))
                break
            case "accessibility":
                // abrir tela de acessibilidade se quiser
                break
            default:
                break
            }
        }
    }
}
