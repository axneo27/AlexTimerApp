//
//  ThemeDefinitions.swift
//  cubeTimer
//
//  Created by Oleksii on 17.03.2025.
//

import SwiftUI

struct Theme1: Theme {
    var name = "Theme 1"
    var bgcolor = CodableColor(Color(red: 16 / 255, green: 17 / 255, blue: 18 / 255))
    var secondaryColor = CodableColor(Color(red: 59 / 255, green: 135 / 255, blue: 150 / 255))
    var thirdColor = CodableColor(Color(red: 42 / 255, green: 160 / 255, blue: 212 / 255))
    var fourthColor = CodableColor(Color(red: 42 / 255, green: 160 / 255, blue: 212 / 255))
}

struct Theme2: Theme {
    var name = "Theme 2"
    var bgcolor = CodableColor(Color(red: 16 / 255, green: 17 / 255, blue: 18 / 255))
    var secondaryColor = CodableColor(Color.orange)
    var thirdColor = CodableColor(Color.red)
    var fourthColor = CodableColor(Color(red: 16 / 255, green: 17 / 255, blue: 18 / 255))
}

struct AnyTheme: Codable {
    let theme: Theme
    
    init(_ theme: Theme) {
        self.theme = theme
    }
    
    enum CodingKeys: CodingKey {
        case type, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "Theme1":
            theme = try container.decode(Theme1.self, forKey: .data)
        case "Theme2":
            theme = try container.decode(Theme2.self, forKey: .data)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown theme type")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch theme {
        case let theme as Theme1:
            try container.encode("Theme1", forKey: .type)
            try container.encode(theme, forKey: .data)
        case let theme as Theme2:
            try container.encode("Theme2", forKey: .type)
            try container.encode(theme, forKey: .data)
        default:
            throw EncodingError.invalidValue(theme, EncodingError.Context(codingPath: [], debugDescription: "Unknown theme type"))
        }
    }
}
