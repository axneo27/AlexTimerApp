//
//  cubeTimerApp.swift
//  cubeTimer
//
//  Created by Oleksii on 12.12.2024.
//

import SwiftUI

@main
struct cubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            NavbarView()
                .environmentObject(DataManager.shared)
                .environmentObject(ThemeManager.shared)
        }
    }
}
