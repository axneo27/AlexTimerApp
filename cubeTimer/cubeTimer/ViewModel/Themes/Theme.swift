//
//  Theme.swift
//  cubeTimer
//
//  Created by Oleksii on 17.03.2025.
//
import SwiftUI

protocol Theme: Codable {
    var name: String { get }
    var bgcolor: CodableColor { get }
    var secondaryColor: CodableColor { get }
    var thirdColor: CodableColor { get }
    var fourthColor: CodableColor { get }
}
