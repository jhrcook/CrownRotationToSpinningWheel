//
//  SpinningWheelTests.swift
//
//
//  Created by Joshua on 1/19/21.
//

@testable import CrownRotationToSpinningWheel
import XCTest

final class SpinningWheelTests: XCTestCase {
    var spinningWheel: SpinningWheel!

    override func setUp() {
        super.setUp()
        spinningWheel = SpinningWheel(damping: 0.1, crownVelocityMemory: 20)
    }

    override func tearDown() {
        spinningWheel = nil
        super.tearDown()
    }

    func testExponentialDecayCalculation() {
        // Given
        let start = 5000.0
        let decayConstant = 0.5
        let halfLife = log(2.0) / decayConstant

        // When
        let final = spinningWheel.exponentialDecay(starting: start, after: halfLife, decayConstant: decayConstant)

        // Then
        XCTAssertEqual(final, start / 2)
    }

    func testTotalTimeOfExponentialDecay() {
        // Given
        let start = 1000.0
        let final = start / 2.0
        let decayConstant = 0.5

        // When
        let duration = spinningWheel.totalTimeOfExponentialDecay(initialValue: start, finalValue: final, decayConstant: decayConstant)

        // Then
        XCTAssertEqual(duration, log(2.0) / decayConstant)
    }

    func testWheelVelocityIncrease() {
        // Given
        let mockData = mockCrownVelocityData(n: 10, timeInterval: 1)

        // When
        mockData.applyData(to: spinningWheel)

        // Then
        XCTAssertTrue(spinningWheel.wheelRotation > 0)
    }

    func testReverseCrownVelocity() {
        // Given
        spinningWheel.damping = 0.0 // no reduction in speed over time
        let mockVelocityData = mockCrownVelocityData(n: 10, timeInterval: 1.0)
        mockVelocityData.applyData(to: spinningWheel.crownVelocity)
        spinningWheel.updateWheelVelocity()
        let initialWheelSpeed = spinningWheel.wheelVelocity

        // When
        var reverseVelocityData = mockCrownVelocityData(n: 5, timeInterval: 1.0)
        reverseVelocityData.angles = reverseVelocityData.angles.map { -1 * $0 }
        reverseVelocityData.applyData(to: spinningWheel.crownVelocity)
        spinningWheel.updateWheelVelocity()
        let finalWheelSpeed = spinningWheel.wheelVelocity

        // Then
        XCTAssertGreaterThan(initialWheelSpeed, finalWheelSpeed)
    }
}
