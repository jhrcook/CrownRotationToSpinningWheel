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
        spinningWheel = SpinningWheel(damping: 0.1, publishingFrequency: 1, crownVelocityMemory: 10)
    }

    override func tearDown() {
        spinningWheel = nil
        super.tearDown()
    }

    func testWheelVelocityIncrease() {
        // Given
        let mockVelocityData = mockCrownVelocityData(n: 10, timeInterval: 1.0)

        // When
        mockVelocityData.applyData(to: spinningWheel)
        spinningWheel.updateWheelVelocity()

        // Then
        XCTAssertEqual(spinningWheel.crownVelocity.velocity(), spinningWheel.wheelVelocity)

        // When
        spinningWheel.updateWheelVelocity()

        // Then
        XCTAssertEqual(spinningWheel.crownVelocity.velocity(), spinningWheel.wheelVelocity)

        // When
        let originalWheelVelocity = spinningWheel.wheelVelocity
        spinningWheel.crownVelocity.data = [] // Crown velocty -> 0
        spinningWheel.updateWheelVelocity()

        // Then
        XCTAssertEqual(spinningWheel.crownVelocity.velocity(), 0.0)
        XCTAssertEqual(spinningWheel.wheelVelocity, originalWheelVelocity * (1 - spinningWheel.damping))
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
