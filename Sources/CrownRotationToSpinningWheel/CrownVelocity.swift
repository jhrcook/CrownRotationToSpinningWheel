//
//  CrownVelocity.swift
//
//
//  Created by Joshua on 1/19/21.
//

import Foundation

class CrownVelocity {
    let memory: Double
    var data = [CrownRotationDatum]()

    init(memory: Double = 0.1) {
        self.memory = max(memory, 0.1)
    }

    func new(angle: Double, at time: Date) {
        data.append(CrownRotationDatum(angle: angle, time: time))
    }

    func velocity(at currentTime: Date = Date()) -> Double {
        data = data.filter { $0.time.timeIntervalSince(currentTime) < memory }

        guard data.count > 0 else {
            return 0.0
        }

        let vs = (1 ..< data.count).map { data[$0] - data[$0 - 1] }
        return vs.reduce(0.0, +) / Double(vs.count)
    }
}

struct CrownRotationDatum {
    let angle: Double
    let time: Date

    static func - (lhs: CrownRotationDatum, rhs: CrownRotationDatum) -> Double {
        return abs(lhs.time.timeIntervalSinceReferenceDate - rhs.time.timeIntervalSinceReferenceDate) * (lhs.angle - rhs.angle)
    }
}
