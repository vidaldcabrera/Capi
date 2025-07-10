//
//  MusicManager.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 27/06/25.
//

import Foundation
import AVFoundation

class MusicManager {
    static let shared = MusicManager()

    private var audioPlayer: AVAudioPlayer?

    func playMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Erro: música \(name).mp3 não encontrada.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Loop infinito
            let savedMusicVolume = UserDefaults.standard.float(forKey: "musicVolume")
            audioPlayer?.volume = savedMusicVolume == 0 ? 0.5 : savedMusicVolume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Erro ao tocar música: \(error)")
        }
    }

    func setVolume(to volume: CGFloat) {
        audioPlayer?.volume = Float(volume)
    }

    func stop() {
        audioPlayer?.stop()
    }
}
