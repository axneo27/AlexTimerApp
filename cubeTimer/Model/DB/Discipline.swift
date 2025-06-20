//
//  Discipline.swift
//  cubeTimer
//
//  Created by Oleksii on 26.12.2024.
//

import Foundation

public enum Discipline: String, Hashable, CaseIterable, Equatable {
    case two, three, four
    case five
    case six
    case all
}

public struct CurrentDate {
    let date = Date()
    
    var fullDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
