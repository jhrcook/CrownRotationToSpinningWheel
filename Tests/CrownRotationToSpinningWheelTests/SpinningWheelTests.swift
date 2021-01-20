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
    let damping = 0.1

    override func setUp() {
        super.setUp()
        spinningWheel = SpinningWheel(damping: damping, publishingFrequency: 1, crownVelocityMemory: 10)
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
        XCTAssertEqual(spinningWheel.wheelVelocity, originalWheelVelocity * (1 - damping))
    }
}
