//
//  DateExtension.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import Foundation

extension Date {
    static func pastDates(for days: Int, from date: Date = Date(), includeStartingDate: Bool = true) -> [Date] {
        var days = days
        var currentDate = date
        var dates = [Date]()
        if includeStartingDate {
            dates.append(currentDate)
            days = days - 1
        }

        for _ in 0..<days {
            guard let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = newDate
            dates.append(currentDate)
        }
        return dates
    }

    var defaultFormatted: String {
        let format: String = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var dateMonthFormatted: String {
        let format: String = "dd MMM"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    var defaultFormatDate: Date {
        let format: String = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }
}
