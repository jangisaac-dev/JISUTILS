//
//  JExtension_Date.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation

extension Date {
    public func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!.addingTimeInterval(60 * 60 * 9)
    }
    
    public func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!.addingTimeInterval(60 * 60 * 9)
    }
    
    public func getCalendar() -> Calendar {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko")
        return cal
    }
    public static var yesterday: Date { return Date().dayBefore }
    public static var tomorrow:  Date { return Date().dayAfter }
    public var lastYear: Date {
        return getCalendar().date(byAdding: .year, value: -1, to: noon)!
    }
    public var dayBefore: Date {
        return getCalendar().date(byAdding: .day, value: -1, to: noon)!
    }
    public var dayAfter: Date {
        return getCalendar().date(byAdding: .day, value: 1, to: noon)!
    }
    public var noon: Date {
        return getCalendar().date(bySettingHour: 00, minute: 0, second: 0, of: self)!
    }
    public var year: Int {
        return getCalendar().component(.year,  from: self)
    }
    public var month: Int {
        return getCalendar().component(.month,  from: self)
    }
    public var day: Int {
       return getCalendar().component(.day,  from: self)
    }
    public var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    public func getDayArray() -> [Date] {
        var dateComponents = DateComponents(year: self.year, month: self.month)
        let calendar = getCalendar()
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        var days = [Date]()
        for d in 0 ..< numDays {
            dateComponents.day = d+1
            days.append(calendar.date(from: dateComponents)!)
        }
        return days
    }
    
    public func getCustom(format: String) -> String {
        return getDateFormat(fmStr: format).string(from: self)
    }
    
    public func dayNumberOfWeek() -> Int {
        return getCalendar().dateComponents([.weekday], from: self).weekday!
    }
    
    public func getHour() -> Int {
        return getCalendar().dateComponents([.hour], from: self).hour!
    }
    
    public func getMin() -> Int {
        return getCalendar().dateComponents([.minute], from: self).minute!
    }
    
    public func getSecond() -> Int {
        return getCalendar().dateComponents([.second], from: self).second!
    }
    
    private func getDateFormat(fmStr: String) -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = fmStr
        
        format.locale = Locale.current
        return format
    }
    
    private func getDateFormat(fmStr: String, loc: Locale = Locale.current) -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = fmStr
        format.locale = loc
        return format
    }
    
    public func removeTimeStamp() -> Date {
        return getCalendar().date(from: getCalendar().dateComponents([.year, .month, .day], from: self))!
    }
    public var ageYear: Int { getCalendar().dateComponents([.year], from: self, to: Date()).year! }
    public var ageMonth: Int { getCalendar().dateComponents([.month], from: self, to: Date()).month! }
    public var ageWeek: Int { getCalendar().dateComponents([.weekOfMonth], from: self, to: Date()).weekOfMonth! }
    public var ageDay: Int { getCalendar().dateComponents([.day], from: self, to: Date()).day! }
}
