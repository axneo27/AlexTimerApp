//
//  StringExt.swift
//  cubeTimer
//
//  Created by Oleksii on 24.12.2024.
//

extension String {
    subscript(i: Int) -> String {
        guard i >= 0 && i < self.count else {return "Out of bounds"}
        return String(self[index(startIndex, offsetBy: i)])
    }
}

