//
//  CodableColor.swift
//  cubeTimer
//
//  Created by Oleksii on 17.03.2025.
//

import SwiftUI

struct CodableColor: Codable {
    var color: Color

    enum CodingKeys: String, CodingKey {
        case color
    }

    init(_ color: Color) {
        self.color = color
    }

    func uiColor() -> UIColor {
        return UIColor(color)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if #available(iOS 14.0, *) {
            let convertedColor = uiColor()
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: convertedColor, requiringSecureCoding: false)
            try container.encode(colorData, forKey: .color)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let colorData = try? container.decode(Data.self, forKey: .color) {
            if #available(iOS 14.0, *) {
                if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    self.color = Color(uiColor)
                    return
                }
            }
        }
        self.color = .black 
    }
}

