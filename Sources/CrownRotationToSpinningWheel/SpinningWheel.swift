//
//  SpinningWheel.swift
//
//
//  Created by Joshua on 1/19/21.
//

import Combine
import Foundation

public class SpinningWheel: ObservableObject {
    // Physics constants
    public var damping: Double

    // API constants
    let publishingFrequency: Double

    // Data management
    public let crownVelocity: CrownVelocity

    // Wheel state
    var previousReadingTimepoint = Date()
    let minimumSignificantVelocity: Double = 0.1
    var wheelVelocity: Double = 0.0
    @Published public var wheelRotation: Double = 0.0

    public init(damping: Double = 0.2, publishingFrequency: Double = 0.1, crownVelocityMemory: Double = 0.1) {
        self.damping = damping
        self.publishingFrequency = publishingFrequency
        crownVelocity = CrownVelocity(memory: crownVelocityMemory)
    }

    public func crownInput(angle: Double, at time: Date) {
        crownVelocity.new(angle: angle, at: time)
    }

    func updateWheelVelocity() {
        let cv = crownVelocity.velocity()
        print("crown velocity: \(cv)")
        if abs(cv) > minimumSignificantVelocity {
            if cv / cv == wheelVelocity / wheelVelocity {
                if abs(cv) > abs(wheelVelocity) {
                    wheelVelocity = cv
                }
            } else {
                wheelVelocity += cv
            }
        } else if abs(wheelVelocity) < minimumSignificantVelocity {
            wheelVelocity = 0.0
        } else {
            wheelVelocity *= (1.0 - damping)
        }
    }

    func updateWheelRotation(after timeInterval: Double) {
        wheelRotation += timeInterval * wheelVelocity
    }

    public func update() {
        updateWheelVelocity()
        let newReadingTimepoint = Date()
        updateWheelRotation(after: newReadingTimepoint.distance(to: previousReadingTimepoint))
        previousReadingTimepoint = newReadingTimepoint
        print("wheel velocity: \(wheelVelocity), wheel rotation: \(wheelRotation)")
    }
}
