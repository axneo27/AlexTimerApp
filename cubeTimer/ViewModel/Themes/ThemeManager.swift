//
//  ThemeManager.swift
//  cubeTimer
//
//  Created by Oleksii on 17.03.2025.
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    private init() {}
    
    static let themes: [Theme] = [Theme1(), Theme2()]
    
    @AppStorage("currentTheme") private var currentThemeData: Data = Data()
    
    @Published var currentTheme: Theme = Theme1() {
        didSet {
            saveCurrentTheme()
        }
    }
    
    private func saveCurrentTheme() {
        let anyTheme = AnyTheme(currentTheme)
        if let encoded = try? JSONEncoder().encode(anyTheme) {
            currentThemeData = encoded
        }
    }
    
    func loadCurrentTheme() {
        if let decoded = try? JSONDecoder().decode(AnyTheme.self, from: currentThemeData) {
            currentTheme = decoded.theme
        } else {
            currentTheme = Theme1()
        }
    }
    
    func changeTheme(to newTheme: Theme) {
        currentTheme = newTheme
    }
}
