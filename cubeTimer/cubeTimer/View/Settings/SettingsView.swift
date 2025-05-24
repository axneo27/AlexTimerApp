//
//  SettingsView.swift
//  cubeTimer
//
//  Created by Oleksii on 17.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var inspectionData = InspectionData.shared
    
    @State private var isMenuOpen = false
    
    var body: some View {
        VStack {
            Text("Settings")
                .frame(maxWidth: .infinity, maxHeight: 60)
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(themeManager.currentTheme.secondaryColor.color)
            
            HStack {
                Text("Appearance")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading, 55)
                    .padding()
                Spacer()
            }
            settingsSector(
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen.toggle()
                    }
                }) {
                    VStack {
                        HStack {
                            Text("Themes")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                            Spacer()
                            Image(systemName: isMenuOpen ? "chevron.up" : "chevron.down")
                                .rotationEffect(.degrees(isMenuOpen ? 0 : 360))
                                .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                                .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                                .font(.headline)
                        }
                        .padding()

                        if isMenuOpen {
                            VStack(spacing: 8) {
                                themeButton(for: Theme1(), label: "Theme 1")
                                themeButton(for: Theme2(), label: "Theme 2")
                            }
                        }
                    }
                }
            )
            
            HStack {
                Text("Timer")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading, 55)
                    .padding()
                Spacer()
            }
            settingsSector(
                Toggle(isOn: $inspectionData.inspectionEnabled) { 
                    Text("Enable 15-second inspection")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                }
                .padding()
            )
            Spacer()
        }
    }
    
    private func settingsSector(_ content: some View) -> some View {
        VStack {
            content
        }
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: 320)
    }

    private func themeButton(for theme: Theme, label: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                themeManager.changeTheme(to: theme)
                isMenuOpen = false
            }
        }) {
            HStack {
                Text(label)
                    .foregroundColor(theme.secondaryColor.color)
                    .font(.headline)
                Spacer()
                Image(systemName: "bookmark.fill")
                    .foregroundColor(theme.secondaryColor.color)
            }
            .padding()
            .background(.gray.opacity(0.05))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
