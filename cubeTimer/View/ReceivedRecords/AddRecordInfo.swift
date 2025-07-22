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
        ScrollView {
            LazyVStack(spacing: 20) {
                
                if let bestSingle = bestSingle {
                    recordCard {
                        bestSingleView(bestSingle)
                    }
                }
                
                if let bestAO5 = bestAO5 {
                    recordCard {
                        bestAOView(
                            title: "Best AO5",
                            result: bestAO5.result ?? 0.0,
                            solves: bestAO5.solves,
                            isShowing: $showingao5Solves
                        )
                    }
                }
                
                if let bestAO12 = bestAO12 {
                    recordCard {
                        bestAOView(
                            title: "Best AO12",
                            result: bestAO12.result ?? 0.0,
                            solves: bestAO12.solves,
                            isShowing: $showingao12Solves
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .popup(isPresented: $showingScrambleGrid) {
            ZStack {
                if shownDiscipline == .three || shownDiscipline == .two || shownDiscipline == .four || shownDiscipline == .five {
                    ScrambleGrid(discipline: $shownDiscipline, scramble: $shownScramble, $showingScrambleGrid)
                        .offset(y: 100)
                }
            }
        }
    }
    
    private func bestSingleView(_ bestSingle: FirestoreBestSingle) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Best Single")
                .font(.headline)
                .foregroundStyle(themeManager.currentTheme.bgcolor.color)
            
            resultView(bestSingle.solve?.result ?? 0.0)
            
            scrambleView(bestSingle.solve?.scramble ?? "No scramble available") {
                showScrambleGrid(bestSingle.solve?.scramble ?? "")
            }
        }
    }
    
    @ViewBuilder
    private func bestAOView(
        title: String,
        result: Double,
        solves: [FirestoreSolve],
        isShowing: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(themeManager.currentTheme.bgcolor.color)
            
            resultView(result)
            
            DisclosureGroup(
                isExpanded: isShowing,
                content: {
                    solvesListView(solves)
                },
                label: {
                    Text("Solves")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            )
            .tint(themeManager.currentTheme.secondaryColor.color)
        }
    }
    
    private func resultView(_ result: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Time")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(formatResult(result))
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
    
    private func scrambleView(_ scramble: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Scramble")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(scramble)
                .font(.footnote)
                .lineLimit(3)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            
            Button(action: action) {
                Label("Show Visual", systemImage: "cube.transparent")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(themeManager.currentTheme.secondaryColor.color)
        }
    }
    
    private func solvesListView(_ solves: [FirestoreSolve]) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(solves.indices, id: \.self) { index in
                solveRowView(solves[index], index: index + 1)
            }
        }
        .padding(.top, 8)
    }
    
    private func solveRowView(_ solve: FirestoreSolve, index: Int) -> some View {
        HStack {
            Text("\(index)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .frame(minWidth: 20, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(formatResult(solve.result))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(solve.scramble)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    //.lineLimit(3)
            }
            
            Spacer()
            
            Button {
                showScrambleGrid(solve.scramble)
            } label: {
                Image(systemName: "cube.transparent")
                    .font(.caption)
            }
            .buttonStyle(.borderless)
            .controlSize(.mini)
            .tint(themeManager.currentTheme.secondaryColor.color)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.background, in: RoundedRectangle(cornerRadius: 6))
    }
    
    private func recordCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func showScrambleGrid(_ scramble: String) {
        if !showingScrambleGrid {
            shownScramble = scramble
            showingScrambleGrid = true
        }
    }
    
    private func formatResult(_ value: Double) -> String {
        String(format: "%.3f", value)
    }
}

