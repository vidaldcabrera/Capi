import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GKScene(fileNamed: "GameScene") {
              // Get the SKScene from the loaded GKScene
              if let sceneNode = scene.rootNode as! GameScene? {
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .resizeFill
                // Present the scene

                if let view = self.view as! SKView? {
                  view.presentScene(sceneNode)
                  view.ignoresSiblingOrder = true
                  #if DEBUG
                  view.showsPhysics = true
                  view.showsFPS = true
                  view.showsNodeCount = true
                  #endif
                }
              }
            }
        
        // Habilita entrada de teclado
        becomeFirstResponder()
    }
    // Suporte a orientação paisagem esquerda em iPhone
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .phone ? .landscapeLeft : .all
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
        guard let key = presses.first?.key,
              let skView = view as? SKView,
              let gameScene = skView.scene as? GamePlayScene else { return }

        switch key.charactersIgnoringModifiers.lowercased() {
        case "a":
            gameScene.playerEntity?.moveComponent?.change(direction: .left)
        case "d":
            gameScene.playerEntity?.moveComponent?.change(direction: .right)
        case " ":
            gameScene.playerEntity?.component(ofType: JumpComponent.self)?.jump()
        default:
            break
        }
    }

    
    // Tecla solta
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key,
              let skView = view as? SKView,
              let gameScene = skView.scene as? GamePlayScene else { return }

        switch key.charactersIgnoringModifiers.lowercased() {
        case "a", "d":
            gameScene.playerEntity?.moveComponent?.change(direction: .none)
        default:
            break
        }
    }

    
}
