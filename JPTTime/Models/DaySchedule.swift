//
//  DaySchedule.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 10/02/2025.
//

import SwiftUI
import SwiftData

@Model
class DaySchedule: Codable {
    enum CodingKeys: CodingKey {
        case enteringDate
        case leavingDate
    }
    
    var enteringDate: Date
    var leavingDate: Date
    
    init(enteringDate: Date, leavingDate: Date) {
        self.enteringDate = enteringDate
        self.leavingDate = leavingDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enteringDate = try container.decode(Date.self, forKey: .enteringDate)
        leavingDate = try container.decode(Date.self, forKey: .leavingDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enteringDate, forKey: .enteringDate)
        try container.encode(leavingDate, forKey: .leavingDate)
    }
}
