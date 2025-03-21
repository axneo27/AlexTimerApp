//
//  DateExt.swift
//  cubeTimer
//
//  Created by Oleksii on 12.01.2025.
//

import Foundation

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
