//
//  GameState.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 23/06/25.
//

import Foundation
import CoreGraphics

class GameState {
    static let shared = GameState()

    var score: Int = 0
    var lives: Int = 3
    var playerPosition: CGPoint = .zero

    private init() {}
}

