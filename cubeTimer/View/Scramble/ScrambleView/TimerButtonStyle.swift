//
//  TimerButtonStyle.swift
//  cubeTimer
//
//  Created by Oleksii on 01.02.2025.
//

import SwiftUI

struct TimerButtonStyle: ButtonStyle {
    @Binding var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(theme.secondaryColor.color.opacity(0.002))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

