import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Carrega e apresenta a cena principal
        if let view = self.view as? SKView {
            let scene = GameScene.newGameScene()
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            // view.showsPhysics = true
            #endif
        }
        
        // Habilita entrada de teclado
        becomeFirstResponder()
    }

    // Suporte a orientação paisagem esquerda em iPhone
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .phone ? .landscapeLeft : .all
    }
    
    // Permite receber eventos de teclado
    override var canBecomeFirstResponder: Bool { true }

    // MARK: - Controles por teclado
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key,
              let skView = view as? SKView,
              let gameScene = skView.scene as? GameScene else { return }
        
        switch key.charactersIgnoringModifiers.lowercased() {
        case "a":
            gameScene.playerEntity?.moveComponent?.change(direction: Direction.left)
        case "d":
            gameScene.playerEntity?.moveComponent?.change(direction: Direction.right)
        case " ":
            gameScene.playerEntity?.moveComponent?.jump()
        default:
            break
        }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key,
              let skView = view as? SKView,
              let gameScene = skView.scene as? GameScene else { return }

        if ["a", "d"].contains(key.charactersIgnoringModifiers.lowercased()) {
            gameScene.playerEntity?.moveComponent?.change(direction: Direction.none)
        }
    }
}
