//
//  GrowingButton.swift
//  cubeTimer
//
//  Created by Oleksii on 27.01.2025.
//
import SwiftUI

struct GrowingButton: ButtonStyle {
    var backCol: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backCol)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
