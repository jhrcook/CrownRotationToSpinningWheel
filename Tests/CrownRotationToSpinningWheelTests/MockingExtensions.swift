//
//  MockingExtensions.swift
//
//
//  Created by Joshua on 1/20/21.
//

@testable import CrownRotationToSpinningWheel
import XCTest

extension XCTestCase {
    struct MockCrownVelocityData {
        let n: Int
        let timeInterval: Double
        let startingDate: Date
        var dates = [Date]()
        var angles = [Double]()

        func applyData(to crownVelocity: CrownVelocity) {
            for (angle, date) in zip(angles, dates) {
                crownVelocity.new(angle: angle, at: date)
            }
        }

        func applyData(to spinnigWheel: SpinningWheel) {
            for (angle, date) in zip(angles, dates) {
                spinnigWheel.crownInput(angle: angle, at: date)
            }
        }
    }

    func mockCrownVelocityData(n: Int, timeInterval: Double, startingDate: Date = Date()) -> MockCrownVelocityData {
        let dates = (0 ..< n).map { startingDate.advanced(by: timeInterval * Double($0)) }
        let angles = (0 ..< n).map { Double($0) }
        return MockCrownVelocityData(n: n, timeInterval: timeInterval, startingDate: startingDate, dates: dates, angles: angles)
    }
}
