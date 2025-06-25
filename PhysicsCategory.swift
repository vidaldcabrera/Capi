import Foundation
import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1 << 0         // 0b0001
    static let spider: UInt32 = 0x1 << 1         // 0b0010
    static let mosquito: UInt32 = 0x1 << 2       // 0b0100
    static let playerAttack: UInt32 = 0x1 << 3   // 0b1000
    static let ground: UInt32 = 0x1 << 4         // 0b1_0000
    static let bat: UInt32 = 0x1 << 5
}
