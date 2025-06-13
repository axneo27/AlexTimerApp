//
//  LineGraphView.swift
//  cubeTimer
//
//  Created by Oleksii on 22.03.2025.
//

import Foundation
import SwiftUI
import Charts

enum GraphType: String, CaseIterable {
    case last20 = "Last 20"
    case last50 = "Last 50"
    case last100 = "Last 100"
    case last500 = "Last 500"
    case all = "All solves"
}

struct LineGraphView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var themeManager = ThemeManager.shared
    
    @Binding var solvesArray: [Solve]
    @State private var visibleSolves: [Solve] = []
    
    @State private var selectedPuzzle: Discipline = .three
    @State private var graphType: GraphType = .last20
    
    var xStrideValue: Int {
        max(1, visibleSolves.count / 4)
    }
    
    var xAxisValues: [Int] {
        Array(stride(from: 0, to: visibleSolves.count, by: xStrideValue))
    }
    
    init(solvesArray: Binding<[Solve]>) {
        self._solvesArray = solvesArray
        UISegmentedControl.appearance().selectedSegmentTintColor = themeManager.currentTheme.secondaryColor.uiColor()
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        UISegmentedControl.appearance().tintColor = themeManager.currentTheme.bgcolor.uiColor()
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
    }
    
    var body: some View {
        ZStack {
            VStack {
                PuzzleMenu(Puzzle: $selectedPuzzle, theme: themeManager.currentTheme)
                Picker("Graph Type", selection: $graphType) {
                    ForEach(GraphType.allCases, id: \ .self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 400)
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Time(seconds)")
                            .rotationEffect(Angle(degrees: -90))
                            .foregroundColor(.white)
                    VStack {
                        Chart {
                            ForEach(Array(visibleSolves.enumerated()), id: \.element.id) { index, solve in
                                LineMark(
                                    x: .value("Solve", index),
                                    y: .value("Result", solve.result)
                                )
                                .foregroundStyle(themeManager.currentTheme.thirdColor.color)
                                PointMark(
                                    x: .value("Solve", index),
                                    y: .value("Result", solve.result)
                                )
                                .foregroundStyle(themeManager.currentTheme.thirdColor.color)
                            }
                        }
                        .padding()
                        .chartXAxis {
                            AxisMarks(position: .bottom, values: xAxisValues) { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [5, 3]))
                                    .foregroundStyle(themeManager.currentTheme.bgcolor.color)
                                AxisValueLabel(content: {
                                    if let intValue = value.as(Int.self) {
                                        Text("\(intValue)").foregroundStyle(themeManager.currentTheme.thirdColor.color)
                                    }
                                })
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .stride(by: 3)) { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [10, 2]))
                                    .foregroundStyle(themeManager.currentTheme.bgcolor.color)
                                AxisValueLabel(content: {
                                    if let intValue = value.as(Int.self) {
                                        Text("\(intValue)").foregroundStyle(themeManager.currentTheme.thirdColor.color)
                                    }
                                })
                            }
                        }
                        Text("Solves numeration")
                            .foregroundColor(.white)
                            .offset(y: -20)
                    }
                    .frame(minWidth: 340)
                    .offset(x: -40)
                }
            }
            .onChange(of: selectedPuzzle) {_ in
                filterSolves()
            }
            .onChange(of: graphType) {_ in
                filterSolves()
            }
        }
        .onAppear {
            filterSolves()
        }
    }
    
    private func filterSolves() {
        visibleSolves = []
        var i = 0
        for solve in solvesArray {
            guard let discipline = Puzzlenames.getByString(solve.discipline!) else {
                return
            }
            if discipline == selectedPuzzle {
                visibleSolves.append(solve)
                i+=1
                switch(graphType){
                case .last20:
                    if i == 20 {return}
                case .last50:
                    if i == 50 {return}
                case .last100:
                    if i == 100 {return}
                case .last500:
                    if i == 500 {return}
                case .all:
                    break
                }
            }
        }
    }
}
