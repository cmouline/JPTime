//
//  Item.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 07/02/2025.
//

import Foundation
import SwiftData

@Model
class Item {
    enum PointingKind: Codable {
        case entering
        case leaving
        
        var text: String {
            switch self {
            case .entering:
                return "entrée"
            case .leaving:
                return "sortie"
            }
        }
    }
    
    var baseTime: Date
    var date: Date
    var month: Int
    var pointingKind: PointingKind
    var timeDifference : Int {
        let baseHour = Calendar.current.component(.hour, from: baseTime)
        let baseMinute = Calendar.current.component(.minute, from: baseTime)
        let diffBaseDate = Calendar.current.date(bySettingHour: baseHour, minute: baseMinute, second: 0, of: Date.now) ?? Date.now

        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let diffDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date.now) ?? Date.now

        return pointingKind == .entering ?
        Calendar.current.dateComponents([.minute], from: diffDate, to: diffBaseDate).minute ?? 0 :
        Calendar.current.dateComponents([.minute], from: diffBaseDate, to: diffDate).minute ?? 0
    }
    
    init(baseTime: Date, date: Date, pointingKind: PointingKind = .entering) {
        self.baseTime = baseTime
        self.date = date
        self.pointingKind = pointingKind
        
        self.month = Calendar.current.component(.month, from: date)
    }
}

extension Item {
    
    static func currentMonthPredicate() -> Predicate<Item> {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())

        return #Predicate<Item> { item in
            item.month == currentMonth
        }
    }
    
    static func lastMonthPredicate() -> Predicate<Item> {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())

        return #Predicate<Item> { item in
            if currentMonth == 1 {
                return item.month == 12
            } else {
                return item.month == currentMonth - 1
            }
        }
    }
}
