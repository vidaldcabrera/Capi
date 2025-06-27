import AVFoundation
import GameplayKit

class VoiceOverManager {
    static let shared = VoiceOverManager()

    private let synthesizer = AVSpeechSynthesizer()

    var isVoiceOverEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "VoiceOverEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "VoiceOverEnabled") }
    }

    // Método normal
    func speak(_ text: String) {
        guard isVoiceOverEnabled else { return }
        speak(text, force: false)
    }

    // Método com opção de "forçar" a fala
    func speak(_ text: String, force: Bool) {
        if !isVoiceOverEnabled && !force { return }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer.speak(utterance)
    }
    
    // Função para atualizar a textura do botão
    func updateAccessibilityButton(_ button: SKSpriteNode) {
        let newImageName = isVoiceOverEnabled ? "disable_button" : "enable_button"
        button.texture = SKTexture(imageNamed: newImageName)
        button.setScale(0.8)
    }
}
