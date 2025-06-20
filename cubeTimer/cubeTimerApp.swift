//
//  cubeTimerApp.swift
//  cubeTimer
//
//  Created by Oleksii on 12.12.2024.
//

import SwiftUI

@main
struct cubeTimerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavbarView()
                .environmentObject(DataManager.shared)
                .environmentObject(ThemeManager.shared)
        }
    }
}
