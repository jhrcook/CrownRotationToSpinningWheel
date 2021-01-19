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
        crownVelocity = CrownVelocity(memory: 10.0)
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
        let N = 10
        let timeInterval: Double = 0.1
        let startDate = Date()
        let dates: [Date] = (0 ..< N).map { startDate.advanced(by: Double($0) * timeInterval) }
        let angles: [Double] = (0 ..< N).map { Double($0) }
        for (date, angle) in zip(dates, angles) {
            crownVelocity.new(angle: angle, at: date)
        }

        // When
        let velocity = crownVelocity.velocity(at: startDate)

        // Then
        let expectedVelocity = 0.1
        XCTAssertTrue(areClose(velocity, expectedVelocity),
                      "\(velocity) and \(expectedVelocity) are not equal.")
    }

    func areClose(_ a: Double, _ b: Double, error: Double = 0.01) -> Bool {
        return abs(a - b) < error
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
