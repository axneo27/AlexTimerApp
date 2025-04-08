//
//  ArrayExt.swift
//  cubeTimer
//
//  Created by Oleksii on 20.03.2025.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
