//
//  CrownVelocityTests.swift
//
//
//  Created by Joshua on 1/19/21.
//

@testable import CrownRotationToSpinningWheel
import Foundation
import XCTest

final class CrownVelocityTests: XCTestCase {
    var crownVelocity: CrownVelocity!

    override func setUp() {
        super.setUp()
        crownVelocity = CrownVelocity(memory: 100_000)
    }

    override func tearDown() {
        crownVelocity = nil
        super.tearDown()
    }

    func testSubtractionOfVelocityData() {
        let date = Date()
        let d1 = CrownRotationDatum(angle: 0, time: date)
        let d2 = CrownRotationDatum(angle: 0, time: date.advanced(by: 1))
        XCTAssertEqual(d2 - d1, 0.0)

        let d3 = CrownRotationDatum(angle: 1, time: date.advanced(by: 1))
        XCTAssertEqual(d3 - d1, 1.0)

        let d4 = CrownRotationDatum(angle: -1, time: date.advanced(by: 1))
        XCTAssertEqual(d4 - d1, -1.0)
    }

    func testVelocityCalculation() {
        // Given
        let mockVelocityData = mockCrownVelocityData(n: 10, timeInterval: 0.1)
        mockVelocityData.applyData(to: crownVelocity)

        // When
        let velocity = crownVelocity.velocity(at: mockVelocityData.startingDate)

        // Then
        let expectedVelocity = 0.1
        XCTAssertTrue(areClose(velocity, expectedVelocity),
                      "\(velocity) and \(expectedVelocity) are not equal.")
    }

    func testAdditionOfNewDataPointAfterSufficientTime() {
        // Given
        let mockVelocityData = mockCrownVelocityData(n: 10, timeInterval: 0.1, startingDate: Date().advanced(by: -200))
        mockVelocityData.applyData(to: crownVelocity)

        // When
        let initialCount = crownVelocity.data.count
        crownVelocity.addLatestTimePoint(&crownVelocity.data)

        // Then
        XCTAssertTrue(crownVelocity.data.count == initialCount + 1)
    }

    func testSlowerVelocityAfterTimeWithNoNewData() {
        // Given (1)
        let mockVelocityData1 = mockCrownVelocityData(n: 10, timeInterval: 0.1, startingDate: Date().advanced(by: -200))
        mockVelocityData1.applyData(to: crownVelocity)

        // When (1)
        let velocity1 = crownVelocity.velocity()

        crownVelocity.clearData()

        // Given (2)
        let mockVelocityData2 = mockCrownVelocityData(n: 10, timeInterval: 0.1, startingDate: Date())
        mockVelocityData2.applyData(to: crownVelocity)

        // When (2)
        let velocity2 = crownVelocity.velocity()

        // Then
        XCTAssertGreaterThan(velocity2, velocity1)
    }

    func areClose(_ a: Double, _ b: Double, error: Double = 0.01) -> Bool {
        return abs(a - b) < error
    }
}
