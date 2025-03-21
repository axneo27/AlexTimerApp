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
    @StateObject var themeManager = ThemeManager.shared
    
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
                    PuzzleMenu(Puzzle: $selectedPuzzle, theme: $themeManager.currentTheme)
                    ScrollView {
                        LazyVStack {
                            RecordInfoBlock(result: $bestSingleResult, date: $singleDate, solves: $singleSolves, theme: $themeManager.currentTheme, type: "Single")
                            RecordInfoBlock(result: $bestAO5Result, date: $ao5Date, solves: $ao5Solves, theme: $themeManager.currentTheme, type: "AO5")
                            RecordInfoBlock(result: $bestAO12Result, date: $ao12Date, solves: $ao12Solves, theme: $themeManager.currentTheme, type: "AO12")
                        }
                        .frame(maxWidth: 350)
                    }
                }
            }
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
        }
    }
    
    private func getRecords() {
        dataManager.context.perform {
            dataManager.context.refreshAllObjects()
        }
        dataManager.getRecordsForDiscipline(dis: selectedPuzzle) {
            receivedRecords in
            self.records = receivedRecords
            changeSingle()
            changeAO5()
            changeAO12()
        }
    }
    
    private func changeSingle() {
        bestSingleResult = getRecordResult("single")
        singleDate = getRecordDate("single")
        singleScramble = getRecordScramble("single")
        singleSolves = getRecordSolves("single")
    }
    
    private func changeAO5() {
        bestAO5Result = getRecordResult("ao5")
        ao5Date = getRecordDate("ao5")
        ao5Solves = getRecordSolves("ao5")
        ao5FirstScramble = getRecordScramble("ao5")
    }
    
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
