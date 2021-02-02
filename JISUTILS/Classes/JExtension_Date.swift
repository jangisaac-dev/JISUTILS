//
//  JExtension_Date.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!.addingTimeInterval(60 * 60 * 9)
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!.addingTimeInterval(60 * 60 * 9)
    }
    
    func getCalendar() -> Calendar {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko")
        return cal
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var lastYear: Date {
        return getCalendar().date(byAdding: .year, value: -1, to: noon)!
    }
    var dayBefore: Date {
        return getCalendar().date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return getCalendar().date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return getCalendar().date(bySettingHour: 00, minute: 0, second: 0, of: self)!
    }
    var year: Int {
        return getCalendar().component(.year,  from: self)
    }
    var month: Int {
        return getCalendar().component(.month,  from: self)
    }
    var day: Int {
       return getCalendar().component(.day,  from: self)
   }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func getDayArray() -> [Date] {
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
    
    func getCustom(format: String) -> String {
        return getDateFormat(fmStr: format).string(from: self)
    }
    
    func dayNumberOfWeek() -> Int {
        return getCalendar().dateComponents([.weekday], from: self).weekday!
    }
    
    func getHour() -> Int {
        return getCalendar().dateComponents([.hour], from: self).hour!
    }
    
    func getMin() -> Int {
        return getCalendar().dateComponents([.minute], from: self).minute!
    }
    
    func getSecond() -> Int {
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
    var ageYear: Int { getCalendar().dateComponents([.year], from: self, to: Date()).year! }
    var ageMonth: Int { getCalendar().dateComponents([.month], from: self, to: Date()).month! }
    var ageWeek: Int { getCalendar().dateComponents([.weekOfMonth], from: self, to: Date()).weekOfMonth! }
    var ageDay: Int { getCalendar().dateComponents([.day], from: self, to: Date()).day! }
}
