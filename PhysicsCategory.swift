import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1 << 0
    static let spider: UInt32 = 0x1 << 1
    static let mosquito: UInt32 = 0x1 << 2
    static let playerAttack: UInt32 = 0x1 << 3   
    static let ground: UInt32 = 0x1 << 4
    static let bat: UInt32 = 0x1 << 5
}

