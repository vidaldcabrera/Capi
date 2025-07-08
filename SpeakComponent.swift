import GameplayKit
import AVFoundation

class SpeakComponent: GKComponent {
    func say(_ text: String) {
        VoiceOverManager.shared.speak(text)
    }
}
