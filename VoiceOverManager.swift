import AVFoundation
import GameplayKit
import UIKit

class VoiceOverManager {
    static let shared = VoiceOverManager()

    private let synthesizer = AVSpeechSynthesizer()

    var isVoiceOverEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "VoiceOverEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "VoiceOverEnabled") }
    }

    private init() {
        // Se nunca foi definido, sincroniza com o estado atual do sistema
        if UserDefaults.standard.object(forKey: "VoiceOverEnabled") == nil {
            let voiceOverAtivo = UIAccessibility.isVoiceOverRunning
            UserDefaults.standard.set(voiceOverAtivo, forKey: "VoiceOverEnabled")
        }

        // Observa mudanças no VoiceOver do sistema
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(systemVoiceOverChanged),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil
        )
    }

    // Fala apenas se estiver ativado pelo app
    func speak(_ text: String) {
        guard isVoiceOverEnabled else { return }
        speak(text, force: false)
    }

    // Força a fala mesmo que esteja desativado no app
    func speak(_ text: String, force: Bool) {
        if !isVoiceOverEnabled && !force { return }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer.speak(utterance)
    }

    // Atualiza a textura de um botão com base no estado do narrador
    func updateAccessibilityButton(_ button: SKSpriteNode) {
        let newImageName = isVoiceOverEnabled ? "disable_button" : "enable_button"
        button.texture = SKTexture(imageNamed: newImageName)
        button.setScale(0.8)
    }

    // Reage quando o sistema muda o estado do VoiceOver
    @objc private func systemVoiceOverChanged() {
        let ativo = UIAccessibility.isVoiceOverRunning
        isVoiceOverEnabled = ativo
        print("VoiceOver do sistema mudou para: \(ativo)")
    }
}
