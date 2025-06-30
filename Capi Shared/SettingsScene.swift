//
//  SettingsScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 17/06/25.
//

import Foundation
import SpriteKit

//class BaseScene: SKScene {
//    func scaleToFill(sprite: SKSpriteNode) {
//        let xScale = size.width / sprite.size.width
//        let yScale = size.height / sprite.size.height
//        sprite.setScale(max(xScale, yScale))
//        sprite.position = .zero
//    }
//
//    func scaleToWidth(sprite: SKSpriteNode, percentage: CGFloat) {
//        let targetWidth = size.width * percentage
//        let scale = targetWidth / sprite.size.width
//        sprite.setScale(scale)
//    }
//}


class SettingsScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
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
        box.zPosition = 5
        addChild(box)
        
        // Título
        let title = SKSpriteNode(imageNamed: "settings_txt")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        title.zPosition = 15
        addChild(title)
        
        // audio label
        let audio = SKSpriteNode(imageNamed: "audio_txt")
        audio.position = CGPoint(x: frame.midX - 100, y: frame.midY + 80)
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

        volumeAudioSlider.position = CGPoint(x: frame.midX + 70, y: frame.midY + 80)
        volumeAudioSlider.zPosition = 20
        addChild(volumeAudioSlider)

        // Atualiza o volume da música em tempo real
        volumeAudioSlider.onValueChanged = { newVolume in
            MusicManager.shared.setVolume(to: newVolume)
            UserDefaults.standard.set(Float(newVolume), forKey: "musicVolume")
        }
        
        

        // Music Label
        let music = SKSpriteNode(imageNamed: "music_txt")
        music.name = "music"
        music.position = CGPoint(x: frame.midX - 100, y: frame.midY + 10)
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
        let languageButton = SKSpriteNode(imageNamed: "language_button")
        languageButton.name = "language_button"
        languageButton.position = CGPoint(x: frame.midX, y: frame.midY - 70)
        languageButton.setScale(0.8)
        languageButton.zPosition = 15
        addChild(languageButton)
        
        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}


// MARK: - CreditsScene

class CreditsScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
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
        box.zPosition = 5
        addChild(box)

        let title = SKSpriteNode(imageNamed: "developers")
        title.position = CGPoint(x: 0, y: view.frame.height * 0.35)
        title.setScale(proportionalScale(view: view, multiplier: 0.6))
        title.zPosition = 6
        addChild(title)

        let names = SKSpriteNode(imageNamed: "names")
        names.position = CGPoint(x: 0, y: 0)
        names.setScale(proportionalScale(view: view, multiplier: 0.6))
        names.zPosition = 6
        addChild(names)

        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}


// MARK: - DifficultyScene

class DifficultyScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
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
        box.zPosition = 5
        addChild(box)

        let name = SKSpriteNode(imageNamed: "difficulty_txt")
        name.position = CGPoint(x: 0, y: view.frame.height * 0.35)
        name.setScale(proportionalScale(view: view, multiplier: 0.6))
        name.zPosition = 6
        addChild(name)

        let difficulties = ["easy_button", "normal_button", "extreme_button"]
        for (index, name) in difficulties.enumerated() {
            let button = SKSpriteNode(imageNamed: name)
            button.name = name
            button.position = CGPoint(x: 0, y: view.frame.height * (0.15 - CGFloat(index) * 0.19))
            button.setScale(proportionalScale(view: view, multiplier: 0.35))
            button.zPosition = 6
            addChild(button)
        }

        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}
