//
//  PuzzleMenu.swift
//  cubeTimer
//
//  Created by Oleksii on 03.02.2025.
//

import SwiftUI

struct PuzzleMenu : View {
    @Binding var Puzzle: Discipline
    @Binding var theme: Theme
    
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
        .tint(theme.secondaryColor.color)
        .font(.largeTitle)
        .padding(-15)
    }
}
