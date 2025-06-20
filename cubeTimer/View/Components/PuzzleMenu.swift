//
//  PuzzleMenu.swift
//  cubeTimer
//
//  Created by Oleksii on 03.02.2025.
//

import SwiftUI

struct PuzzleMenu : View {
    @Binding var Puzzle: Discipline
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body : some View {
        Menu(Puzzlenames[Puzzle] ?? "Select") {
            ForEach(Discipline.allCases.dropLast(), id: \.self) { puzzle in
                Button() {
                    Puzzle = puzzle
                }
                label: {
                    Text((Puzzlenames[puzzle] ?? ""))
                }
            }
        }
        .colorScheme(.dark)
        .padding()
        .buttonStyle(.borderedProminent)
        .tint(themeManager.currentTheme.secondaryColor.color)
        .font(.largeTitle)
        .padding(-15)
    }
}
