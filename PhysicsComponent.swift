
import SpriteKit
import GameplayKit
import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1 << 0
    static let mosquito: UInt32 = 0x1 << 1
    static let chao: UInt32 = 0x1 << 2
    // Adicione outras categorias se quiser
}

