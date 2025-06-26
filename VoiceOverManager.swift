import AVFoundation

class VoiceOverManager {
    static let shared = VoiceOverManager()

    private let synthesizer = AVSpeechSynthesizer()

    var isVoiceOverEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "VoiceOverEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "VoiceOverEnabled") }
    }

    func speak(_ text: String) {
        guard isVoiceOverEnabled else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer.speak(utterance)
    }
}
