//
//  JExtension_String.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit

extension String {
    public var uni2String: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, "Any-Hex/Java" as NSString, true)

        return mutableString as String
    }
    
    public var getTimeString: String {
        var str = self
        
        let i = str.index(str.startIndex, offsetBy: 2)
        str.insert(":", at: i)
        return str
    }
    
    public func attrString(color: UIColor, font: UIFont) -> NSAttributedString {
        let attrs = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font
        ]
        return NSAttributedString(string: self, attributes: attrs )
    }
    
    public func attrString(color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [ NSAttributedString.Key.foregroundColor: color ])
    }
    
    public func attrString(font: UIFont) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [ NSAttributedString.Key.font: font ])
    }
    
    public func attrString(_ underLine: Bool = true) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue ])
    }
    
    private var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    public var html2String: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public var encodeUrl : String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    public var decodeUrl : String? {
        return self.removingPercentEncoding
    }
    
    public  var localized: String {
       return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
    public func getYMDate(fm: String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = fm
        return format.date(from: self)
    }
    
    public func getDateFromString(format: String = "yyyyMMdd") -> Date? {
        if self.count == 0 {
            return nil
        }
        let dF = getDateFormatter()
        dF.dateFormat = format
        return dF.date(from: self)
    }
    
    public func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.calendar = Calendar.current
        return dateFormatter
    }
    
    public func getCustomDate(inputFormat: String = "yyyyMMdd", outputFormat: String) -> String {
        if self.count == 0 {
            return ""
        }
        let dF = getDateFormatter()
        dF.dateFormat = inputFormat
        return dF.date(from: self)?.getCustom(format: outputFormat) ?? ""
    }
    
    public var CGFloatValue : CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }

        return CGFloat(doubleValue)
    }
    
    public var toUIColor : UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
