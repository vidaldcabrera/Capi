//
//  CustomSlider.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 26/06/25.
//

import Foundation
import SpriteKit

class CustomSlider: SKNode {
    private let track: SKSpriteNode
    private let thumb: SKSpriteNode

    private let minValue: CGFloat
    private let maxValue: CGFloat
    private var currentValue: CGFloat {
        didSet {
            updateThumbPosition()
            onValueChanged?(currentValue)
        }
    }

    var value: CGFloat {
        get { currentValue }
        set {
            currentValue = min(max(newValue, minValue), maxValue)
            updateThumbPosition()
        }
    }

    var onValueChanged: ((CGFloat) -> Void)?

    private let trackLength: CGFloat

    init(trackImage: String, thumbImage: String, min: CGFloat, max: CGFloat, initial: CGFloat) {
        self.track = SKSpriteNode(imageNamed: trackImage)
        self.thumb = SKSpriteNode(imageNamed: thumbImage)
        self.minValue = min
        self.maxValue = max
        self.currentValue = initial
        self.trackLength = 100

        super.init()
        self.isUserInteractionEnabled = true

        track.zPosition = 1
        track.setScale(2.1)
        addChild(track)

        thumb.zPosition = 2
        thumb.setScale(1.0)
        addChild(thumb)

        updateThumbPosition()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateThumbPosition() {
        let ratio = (currentValue - minValue) / (maxValue - minValue)
        let xOffset = (ratio - 0.5) * trackLength
        thumb.position = CGPoint(x: xOffset, y: 0)
    }

    private func updateValue(for location: CGPoint) {
        let clampedX = max(-trackLength/2, min(trackLength/2, location.x))
        let ratio = (clampedX + trackLength / 2) / trackLength
        currentValue = minValue + ratio * (maxValue - minValue)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Só começa se o toque estiver no thumb
        if thumb.contains(location) {
            updateValue(for: location)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Só move se o dedo já estiver no thumb
        if thumb.contains(location) {
            updateValue(for: location)
        }
    }
}
