//
//  SpinningWheel.swift
//
//
//  Created by Joshua on 1/19/21.
//

import Combine
import Foundation

class SpinningWheel: ObservableObject {
    // Physics constants
    let momentOfInertia: Float
    internal var angularVelocity: Float = 0.0
    let friction: Float

    // API constants
    let publishingFrequency: Float

    init(momentOfInertia: Float = 1.0, friction: Float = 0.2, publishingFrequency: Float = 0.1) {
        self.momentOfInertia = momentOfInertia
        self.friction = friction
        self.publishingFrequency = publishingFrequency
    }
}
