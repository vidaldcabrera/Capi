import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let spider: UInt32 = 0b10
    static let playerAttack: UInt32 = 0b100
    static let ground: UInt32 = 0b1000
}

