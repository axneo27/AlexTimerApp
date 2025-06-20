//
//  StatisticsView.swift
//  cubeTimer
//
//  Created by Oleksii on 18.02.2025.
//

import Foundation
import SwiftUI

struct RecordsView : View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var themeManager = ThemeManager.shared
    
    @State var selectedPuzzle: Discipline = .three
    @State var records: [String : Record?] = [:]
    
    @State var bestSingleResult: Float = 0.0
    @State var singleDate: Date = .now
    @State var singleSolves: [Solve] = []
    @State var singleScramble: String = ""
    
    @State var bestAO5Result: Float = 0.0
    @State var ao5Date: Date = .now
    @State var ao5Solves: [Solve] = []
    @State var ao5FirstScramble: String = ""
    
    @State var bestAO12Result: Float = 0.0
    @State var ao12Date: Date = .now
    @State var ao12Solves: [Solve] = []
    @State var ao12FirstScramble: String = ""
    
    @State var showingScrambleGrid: Bool = false
    @State var shownScramble: String = ""
    @State var shownDiscipline: Discipline = .three
    
    var recordsDisciplineEmpty: Bool {
        get {
            if records["single"] == nil &&
                records["ao5"] == nil &&
                records["ao12"] == nil {
                return true
            }
            return false
        }
    }
    
    var body : some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [themeManager.currentTheme.bgcolor.color, themeManager.currentTheme.secondaryColor.color]), startPoint: UnitPoint(x: 0.5, y: 0.1), endPoint: UnitPoint(x: 0.5, y: 1.3))
                .ignoresSafeArea()
            VStack{
                if dataManager.getSolveCount() == 0 {
                    Text("NO RECORDS")
                        .foregroundColor(themeManager.currentTheme.thirdColor.color)
                        .font(.system(size: 30))
                }
                else {
                    Spacer().frame(height: 40)
                    PuzzleMenu(Puzzle: $selectedPuzzle)
                        .padding()
                    ScrollView {
                        LazyVStack {
                            RecordInfoBlock(result: $bestSingleResult,
                                date: $singleDate,
                                solves: $singleSolves,
                                theme: $themeManager.currentTheme,
                                someScrambleShowing: $showingScrambleGrid,
                                shownScramble: $shownScramble,
                                shownDiscipline: $shownDiscipline,
                                type: "Single"
                                )
                            RecordInfoBlock(result: $bestAO5Result,
                                date: $ao5Date,
                                solves: $ao5Solves,
                                theme: $themeManager.currentTheme,
                                someScrambleShowing: $showingScrambleGrid,
                                shownScramble: $shownScramble,
                                shownDiscipline: $shownDiscipline,
                                type: "AO5")
                            RecordInfoBlock(result: $bestAO12Result,
                                date: $ao12Date,
                                solves: $ao12Solves,
                                theme: $themeManager.currentTheme,
                                someScrambleShowing: $showingScrambleGrid,
                                shownScramble: $shownScramble,
                                shownDiscipline: $shownDiscipline,
                                type: "AO12")
                        }
                        .frame(maxWidth: 350)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: bestSingleResult)
            .onReceive(dataManager.$solvesCount, perform: {_ in
                getRecords()
            })
            .onChange(of: selectedPuzzle, perform: {_ in
                getRecords()
            })
            .onAppear {
                getRecords()
//                themeManager.loadCurrentTheme()
            }
            .popup(isPresented: $showingScrambleGrid) {
                ZStack {
                    if selectedPuzzle == .all || selectedPuzzle == .three || selectedPuzzle == .two || selectedPuzzle == .four || selectedPuzzle == .five {
                        ScrambleGrid(discipline: $shownDiscipline, scramble: $shownScramble, $showingScrambleGrid)
                    }
                }
            }
        }
    }
    
    @MainActor
    private func getRecords() {
        dataManager.context.perform {
            dataManager.context.refreshAllObjects()
        }
        dataManager.getRecordsForDiscipline(dis: selectedPuzzle) { receivedRecords in
            DispatchQueue.main.async {
                self.records = receivedRecords
                self.changeSingle()
                
                if let d = dataManager.byDiscipline[selectedPuzzle] {
                    if d.count >= 5 {
                        self.changeAO5()
                    } else {
                        self.bestAO5Result = 0.0
                        self.ao5Date = .now
                        self.ao5Solves = []
                        self.ao5FirstScramble = ""
                    }
                    
                    if d.count >= 12 {
                        self.changeAO12()
                    } else {
                        self.bestAO12Result = 0.0
                        self.ao12Date = .now
                        self.ao12Solves = []
                        self.ao12FirstScramble = ""
                    }
                }
            }
        }
    }
    
    @MainActor
    private func changeSingle() {
        bestSingleResult = getRecordResult("single")
        singleDate = getRecordDate("single")
        singleScramble = getRecordScramble("single")
        singleSolves = getRecordSolves("single")
    }

    @MainActor
    private func changeAO5() {
        bestAO5Result = getRecordResult("ao5")
        ao5Date = getRecordDate("ao5")
        ao5Solves = getRecordSolves("ao5")
        ao5FirstScramble = getRecordScramble("ao5")
    }

    @MainActor
    private func changeAO12() {
        bestAO12Result = getRecordResult("ao12")
        ao12Date = getRecordDate("ao12")
        ao12Solves = getRecordSolves("ao12")
        ao12FirstScramble = getRecordScramble("ao12")
    }
    
    private func getRecordResult(_ type: String) -> Float {
        if let record = records[type] {
            return record?.result ?? 0.0
        }
        return 0.0
    }
    
    private func getRecordDate(_ type: String) -> Date {
        if let record = records[type] {
            return record?.date ?? .now
        }
        return .now
    }
    
    private func getRecordSolvesCount(_ type: String) -> Int {
        if let record = records[type] {
            return record?.solves?.count ?? 0
        }
        return 0
    }
    
    private func getRecordScramble(_ type: String) -> String {
        if let record = records[type] {
            if let solve = record?.solves?.firstObject as? Solve {
                return solve.scramble ?? "Error: no scramble"
            }
            return "Error: no solves for record (or no record)"
        }
        return "Error: no record"
    }
    
    private func getRecordSolves(_ type: String) -> [Solve] {
        if let record = records[type] {
            if let solves = record?.solves?.array as? [Solve] {
                return solves
            }
            return []
        }
        return []
    }
    
}

struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView().environmentObject(DataManager.shared)
    }
}
