//
//  AddRecordInfo.swift
//  cubeTimer
//
//  Created by Oleksii on 18.06.2025.
//

import SwiftUI

struct AddRecordInfo: View {
    @ObservedObject var themeManager: ThemeManager = .shared
    
    @State var bestSingle: FirestoreBestSingle?
    @State var bestAO5: FirestoreBestAO?
    @State var bestAO12: FirestoreBestAO?
    
    @State var showingScrambleGrid: Bool = false
    @State var shownScramble: String = ""
    @State var shownDiscipline: Discipline
    
    @State var showingao5Solves: Bool = false
    @State var showingao12Solves: Bool = false
    
    var body: some View {
        LazyVStack {
            if let bestSingle = bestSingle {
                recordsSector{
                    VStack {
                        Text("Best single")
                        Text("Result: \(formatResult(bestSingle.solve?.result ?? 0.0))")
                        Text("Scramble: \(bestSingle.solve?.scramble ?? "no scramble")")
                        ClickableButton(text: "Show scramble visual", action: {
                            if !showingScrambleGrid {
                                showingScrambleGrid = true
                                shownScramble = bestSingle.solve?.scramble ?? ""
                            }
                        }, color: themeManager.currentTheme.secondaryColor.color)
                    }
                    .frame(minWidth: 250)
                }
            }
            if let bestAO5 = bestAO5 {
                recordsSector{
                    VStack {
                        Text("Best AO5")
                        Text("Result: \(formatResult(bestAO5.result ?? 0.0))")
                        ClickableButton(text: showingao5Solves ? "Hide solves" : "Show solves", action: {
                            showingao5Solves.toggle()
                        }, color: themeManager.currentTheme.secondaryColor.color)
                        if showingao5Solves {
                            Text("adsfasdf")
                            solvesList(bestAO5.solves)
                        }
                    }
                    .frame(minWidth: 250)
                }
            }
            if let bestAO12 = bestAO12 {
                recordsSector{
                    VStack {
                        Text("Best AO12")
                        Text("Result: \(formatResult(bestAO12.result ?? 0.0))")
                        
                        ClickableButton(text: showingao12Solves ? "Hide solves" : "Show solves", action: {
                            showingao12Solves.toggle()
                        }, color: themeManager.currentTheme.secondaryColor.color)
                        
                        if showingao12Solves {
                            solvesList(bestAO12.solves)
                        }
                    }
                    .frame(minWidth: 250)
                }
            }
        }
        .frame(maxWidth: 400)
        .popup(isPresented: $showingScrambleGrid) {
            ZStack {
                if shownDiscipline == .all || shownDiscipline == .three || shownDiscipline == .two || shownDiscipline == .four || shownDiscipline == .five {
                    ScrambleGrid(discipline: $shownDiscipline, scramble: $shownScramble, $showingScrambleGrid)
                }
            }
            .frame(width: 200, height: 200)
        }
    }
    
    func recordsSector(_ opacity: Double = 0.1, _ content: () -> some View) -> some View {
        VStack {
            content()
        }
        .background(.gray.opacity(opacity))
        .cornerRadius(8)
        .frame(maxWidth: 400)
    }
    
    func solvesList(_ firestoreSolves: [FirestoreSolve]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(firestoreSolves, id: \.self) { solve in
                    solveInfo(solve)
                }
            }
        }
        .frame(maxWidth: 250, maxHeight: 250)
    }
    
    func solveInfo(_ firestoreSolve: FirestoreSolve) -> some View {
        recordsSector(0.4) {
            VStack {
                Text("Result: \(formatResult(firestoreSolve.result))")
                Text("Scramble: \(firestoreSolve.scramble)")
                ClickableButton(text: "Show scramble visual", action: {
                    if !showingScrambleGrid {
                        showingScrambleGrid = true
                        shownScramble = firestoreSolve.scramble
                    }
                }, color: themeManager.currentTheme.secondaryColor.color)
            }
        }
        .frame(maxWidth: 240)
    }
    
    private func formatResult(_ v: Double) -> String {
        return String(format: "%.3f", v)
    }
    
}
