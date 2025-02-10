//
//  Account.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 10/02/2025.
//

import SwiftUI
import SwiftData

enum WorkDays: Int, CaseIterable {    
    case monday     = 1
    case tuesday    = 2
    case wednesday  = 3
    case thursday   = 4
    case friday     = 5
    
    var text: String {
        switch self {
        case .monday:
            return "Lundi"
        case .tuesday:
            return "Mardi"
        case .wednesday:
            return "Mercredi"
        case .thursday:
            return "Jeudi"
        case .friday:
            return "Vendredi"
        }
    }
}

@Model
class Account {
    var workingDays: [Int: Bool] = [:]
    var weekSchedule: [Int: DaySchedule] = [:]
    
    init(workingDays: [Int: Bool], weekSchedule: [Int: DaySchedule]) {
        self.workingDays = workingDays
        self.weekSchedule = weekSchedule
    }
}

