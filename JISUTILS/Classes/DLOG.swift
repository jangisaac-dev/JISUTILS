//
//  DLOG.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation

open class DLOG {
    public static func e<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        let th = Thread.current.isMainThread ? "main": Thread.current.name ?? "-"
        if let obj = object {
            print("**JUTIL** \(Date()) \(th) \(filename.components(separatedBy: "/").last ?? "") (LINE:\(line))::\(funcName)\n    **** \(obj)")
            
        } else {
            print("**JUTIL** \(Date()) \(th) \(filename.components(separatedBy: "/").last ?? "") (LINE:\(line))::\(funcName)")
            
        }
        #endif
    }

}
