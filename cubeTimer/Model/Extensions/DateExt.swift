//
//  DateExt.swift
//  cubeTimer
//
//  Created by Oleksii on 12.01.2025.
//

import Foundation

//extension Date {
//    private static let formatterCacheQueue = DispatchQueue(label: "formatterCache.queue", attributes: .concurrent)
//    private static var _formatterCache = [String: DateFormatter]()
//
//    private static var formatterCache: [String: DateFormatter] {
//        get { formatterCacheQueue.sync { _formatterCache } }
//        set { formatterCacheQueue.async(flags: .barrier) { _formatterCache = newValue } }
//    }
//
//    func toString(dateFormat format: String) -> String {
//        if let formatter = Self.formatterCache[format] {
//            return formatter.string(from: self)
//        }
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        Self.formatterCache[format] = formatter
//        return formatter.string(from: self)
//    }
//
//    static func clearFormatterCache() {
//        formatterCacheQueue.async(flags: .barrier) {
//            _formatterCache.removeAll()
//        }
//    }
//}

struct DateFormatting {
    private static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }() // added this

    static func string(from date: Date) -> String {
        return formatter.string(from: date)
    }
}
