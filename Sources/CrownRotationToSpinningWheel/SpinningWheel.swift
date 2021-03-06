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
    public internal(set) var wheelVelocity: Double = 0.0
    @Published public var wheelRotation: Double = 0.0

    public init(damping: Double = 0.2, crownVelocityMemory: Double = 1) {
        self.damping = damping
        crownVelocity = CrownVelocity(memory: crownVelocityMemory)
    }

    public func crownInput(angle: Double, at time: Date) {
        crownVelocity.new(angle: angle, at: time)
        updateWheelRotationAngle()
    }

    func updateWheelVelocity() {
        let cv = crownVelocity.velocity()
        if abs(cv) > minimumSignificantVelocity {
            wheelVelocity = cv
        } else {
            wheelVelocity = decay(wheelVelocity: wheelVelocity)
        }
    }

    func updateWheelRotationAngle() {
        updateWheelVelocity()
        wheelRotation = calculateFinalAngle(initialAngle: wheelRotation, velocity: wheelVelocity)
    }

    func calculateFinalAngle(initialAngle: Double, velocity: Double) -> Double {
        if abs(velocity) < minimumSignificantVelocity { return wheelRotation }
        let dAngle = 0.5 * (velocity - minimumSignificantVelocity) * abs(totalTimeOfExponentialDecay(initialValue: velocity, finalValue: minimumSignificantVelocity))
        return dAngle + initialAngle
    }

    func decay(wheelVelocity wv: Double, until newTimePoint: Date = Date()) -> Double {
        if abs(wheelVelocity) < minimumSignificantVelocity { return 0 }

        let dTime = previousReadingTimepoint.distance(to: newTimePoint)
        let newWheelVelocity = exponentialDecay(starting: wv, after: dTime)
        previousReadingTimepoint = newTimePoint

        return newWheelVelocity
    }

    func exponentialDecay(starting from: Double, after time: TimeInterval, decayConstant: Double = 0.1) -> Double {
        from * exp(-1 * decayConstant * time)
    }

    func totalTimeOfExponentialDecay(initialValue: Double, finalValue: Double, decayConstant: Double = 0.1) -> Double {
        -1.0 * (1.0 / decayConstant) * log(abs(finalValue) / abs(initialValue))
    }
}
