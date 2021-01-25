//
//  CrownVelocity.swift
//
//
//  Created by Joshua on 1/19/21.
//

import Foundation

public class CrownVelocity {
    let memory: Double
    var data = [CrownRotationDatum]()

    public init(memory: Double = 1) {
        self.memory = memory
    }

    public func new(angle: Double, at time: Date) {
        data.append(CrownRotationDatum(angle: angle, time: time))
    }

    public func velocity(at currentTime: Date = Date()) -> Double {
        data = data.filter { abs($0.time.timeIntervalSince(currentTime)) < memory }
        addLatestTimePoint(&data)
        guard data.count > 1 else {
            return 0.0
        }
        let vs = (1 ..< data.count).map { data[$0] - data[$0 - 1] }
        return vs.reduce(0.0, +) / Double(vs.count)
    }

    func addLatestTimePoint(_ data: inout [CrownRotationDatum], minimumTimeDifference: Double = 0.1) {
        guard let lastDatum: CrownRotationDatum = data.last else { return }
        let newDate = Date()
        if newDate.timeIntervalSince1970 - lastDatum.time.timeIntervalSince1970 > minimumTimeDifference {
            data.append(CrownRotationDatum(angle: lastDatum.angle, time: newDate))
        }
    }
}

struct CrownRotationDatum {
    let angle: Double
    let time: Date

    static func - (lhs: CrownRotationDatum, rhs: CrownRotationDatum) -> Double {
        return abs(lhs.time.timeIntervalSinceReferenceDate - rhs.time.timeIntervalSinceReferenceDate) * (lhs.angle - rhs.angle)
    }
}
