import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            let scene = GameScene.newGameScene()
            view.presentScene(scene)
            view.ignoresSiblingOrder = true

            #if DEBUG
            view.showsPhysics = true
            view.showsFPS = true
            #endif
        }
    }

    // Ativa suporte a teclado
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }

    // Tecla pressionada
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        if let skView = self.view as? SKView,
           let gameScene = skView.scene as? GameScene {
            switch key.charactersIgnoringModifiers.lowercased() {
            case "a":
                gameScene.playerEntity?.moveComponent?.change(direction: .left)
            case "d":
                gameScene.playerEntity?.moveComponent?.change(direction: .right)
            case " ":
                gameScene.playerEntity?.moveComponent?.jump()
            default:
                break
            }
        }
    }

    // Tecla solta
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        if let skView = self.view as? SKView,
           let gameScene = skView.scene as? GameScene {
            switch key.charactersIgnoringModifiers.lowercased() {
            case "a", "d":
                gameScene.playerEntity?.moveComponent?.change(direction: .none)
            default:
                break
            }
        }
    }
}
