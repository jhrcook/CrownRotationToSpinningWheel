//
//  SpinningWheel.swift
//
//
//  Created by Joshua on 1/19/21.
//

import Combine
import Foundation

public class SpinningWheel: ObservableObject {
    // Physics
    public var damping: Double
    public let crownVelocity: CrownVelocity

    // Wheel state
    var previousReadingTimepoint = Date()
    let minimumSignificantVelocity: Double = 0.1
    var wheelVelocity: Double = 0.0
    @Published public var wheelRotation: Double = 0.0

    public init(damping: Double = 0.2, crownVelocityMemory: Double = 0.1) {
        self.damping = damping
        crownVelocity = CrownVelocity(memory: crownVelocityMemory)
    }

    public func crownInput(angle: Double, at time: Date) {
        crownVelocity.new(angle: angle, at: time)
    }

    func updateWheelVelocity() {
        let cv = crownVelocity.velocity()
        if abs(cv) > minimumSignificantVelocity {
            if crownAndWheelAreRotatingInTheSaveDirection(cv: cv) {
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

    func crownAndWheelAreRotatingInTheSaveDirection(cv: Double) -> Bool {
        return cv / cv == wheelVelocity / wheelVelocity
    }

    func updateWheelRotation(after timeInterval: Double) {
        wheelRotation += timeInterval * wheelVelocity
    }

    public func update() {
        updateWheelVelocity()
        let newReadingTimepoint = Date()
        updateWheelRotation(after: newReadingTimepoint.distance(to: previousReadingTimepoint))
        previousReadingTimepoint = newReadingTimepoint
    }
}
