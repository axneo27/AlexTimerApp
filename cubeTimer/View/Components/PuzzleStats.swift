//
//  PuzzleStats.swift
//  cubeTimer
//
//  Created by Oleksii on 11.02.2025.
//

import SwiftUI

struct PuzzleStats : View {
    @Binding var Puzzle: Discipline
    @Binding var visibleStats: Int
    @Binding var allSolves: [Solve]
    
    var body : some View {
        Menu(Puzzlenames[Puzzle] ?? "Select") {
            ForEach(Discipline.allCases, id: \.self) { puzzle in
                Button(Puzzlenames[puzzle] ?? "") {
                    Puzzle = puzzle
                }
            }
        }
        .colorScheme(.dark)
        .padding()
        .buttonStyle(.borderedProminent)
        .font(.system(size: 22))
        .padding(-15)
    }
}

