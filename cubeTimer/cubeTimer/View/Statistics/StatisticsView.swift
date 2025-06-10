//
//  StatisticsView.swift
//  cubeTimer
//
//  Created by Oleksii on 03.01.2025.
//

import Foundation
import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showAlert = false
    @Binding var solvesArray: [Solve]
    
    @State private var visibleSolves: [Solve] = []
    
    @State var selectedPuzzle: Discipline = .all
    
    enum viewType {
        case table, graph
    }
    
    @State var selectedView = viewType.table
    
    @State var showingScrambleGrid: Bool = false
    @State var shownScramble: String = ""
    @State var shownDiscipline: Discipline = .three

    var body: some View {
        ZStack {
            backgroundView
            VStack {
                if solvesArray.isEmpty {
                    NoSolvesView()
                } else {
                    switchViewButtons()
                    if selectedView == .table {
                        PuzzleStats(Puzzle: $selectedPuzzle, visibleStats: .constant(visibleSolves.count), allSolves: $solvesArray)
                            .tint(themeManager.currentTheme.secondaryColor.color)
                            .onChange(of: selectedPuzzle) { _ in filterSolves() }

                        DeleteButtonView(deleteAction: deleteAllSolves, count: visibleSolves.count)

                        if visibleSolves.isEmpty {
                            NoSolvesForPuzzleView(puzzleName: Puzzlenames[selectedPuzzle]!)
                        } else {
                            SolvesListView(solves: visibleSolves, deleteAction: deleteSolve)
                        }
                    } else {
                        LineGraphView(solvesArray: $solvesArray)
                    }
                }
            }
            .popup(isPresented: $showingScrambleGrid) {
                ZStack {
                    if selectedPuzzle == .all || selectedPuzzle == .three || selectedPuzzle == .two || selectedPuzzle == .four || selectedPuzzle == .five {
                        ScrambleGrid(discipline: $shownDiscipline, scramble: $shownScramble, $showingScrambleGrid)
                    }
                }
            }
            .alert(isPresented: $showAlert) { // this is all dangerous so will refactor
                Alert(title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete these solves (\(Puzzlenames[selectedPuzzle]!))?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if selectedPuzzle != .all {
                            dataManager.deleteAllSolves(where: selectedPuzzle)
                            visibleSolves.removeAll()
                            solvesArray.removeAll{$0.discipline! == Puzzlenames[selectedPuzzle]!}
                        } else {
                            dataManager.deleteAllSolves()
                            solvesArray.removeAll()
                            visibleSolves.removeAll()
                        }
                    },
                    secondaryButton: .cancel())
            }
            .onAppear {
//                fetchSolves()
                filterSolves()
            }
        }
    }

    private var backgroundView: some View {
        LinearGradient(gradient: Gradient(colors: [themeManager.currentTheme.bgcolor.color, themeManager.currentTheme.secondaryColor.color]), startPoint: UnitPoint(x: 0.5, y: 0.1), endPoint: UnitPoint(x: 0.5, y: 1.3))
            .ignoresSafeArea()
    }

    private func NoSolvesView() -> some View {
        Text("NO SOLVES")
            .foregroundColor(themeManager.currentTheme.thirdColor.color)
            .font(.system(size: 30))
    }

    private func NoSolvesForPuzzleView(puzzleName: String) -> some View {
        Text("NO SOLVES FOR \(puzzleName)")
            .foregroundColor(themeManager.currentTheme.thirdColor.color)
            .font(.system(size: 30))
    }

    private func DeleteButtonView(deleteAction: @escaping () -> Void, count: Int) -> some View {
        Button(action: deleteAction) {
            Text("DELETE ALL (\(count))")
        }
        .buttonStyle(GrowingButton(backCol: .red))
        .foregroundColor(.white)
    }
    
    private func SolvesListView(solves: [Solve], deleteAction: @escaping (IndexSet) -> Void) -> some View {
        List {
            ForEach(solves.reversed(), id: \.self) { solve in
                if let date = solve.date, let dis = solve.discipline,
                   let sc = solve.scramble, let solveid = solve.id {
                    SolveInfoBlock(solveDate: date, solveDiscipline: dis, solveResult: solve.result, solveScramble: sc, solveID: solveid, $showingScrambleGrid, $shownScramble, $shownDiscipline)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.clear)
//                        .padding(8)
                }
            }
            .onDelete(perform: deleteAction)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func switchViewButtons() -> some View {
        HStack {
            Button(action: {
                selectedView = .table
            }) {
                Text("Table")
                    .padding()
                    .background(selectedView == .table ? themeManager.currentTheme.secondaryColor.color : themeManager.currentTheme.bgcolor.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: {
                selectedView = .graph
            }) {
                Text("Graph")
                    .padding()
                    .background(selectedView == .graph ? themeManager.currentTheme.secondaryColor.color : themeManager.currentTheme.bgcolor.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: 500)
    }

    private func filterSolves() {
        visibleSolves = solvesArray.filter { solve in
            selectedPuzzle == .all || solve.discipline == Puzzlenames[selectedPuzzle]
        }
    }

    private func deleteSolve(at offsets: IndexSet) {
        for index in offsets {
            let solveIndex = visibleSolves.count - index - 1
            guard let solve = visibleSolves[safe: solveIndex], let puzzleName = solve.discipline,
                  let discipline = Puzzlenames.getByString(puzzleName) else {
                return
            }
            
            dataManager.deleteSolve(at: solveIndex, items: solvesArray) { _ in
                DispatchQueue.main.async {
                    dataManager.solvesCount -= 1
                    self.dataManager.setRecords(dis: discipline) { _ in } // moved here
                    
                    solvesArray.removeAll { $0.id == solve.id }
                    filterSolves()
                }
            }
        }
    }

    private func deleteAllSolves() {
        !showingScrambleGrid ? showAlert = true : ()
    }

    private func fetchSolves() {
        do {
            try dataManager.fetchAllSolves { solves in
                solvesArray = solves ?? []
                filterSolves()
            }
        } catch {
            print("Error fetching solves")
        }
    }
}
