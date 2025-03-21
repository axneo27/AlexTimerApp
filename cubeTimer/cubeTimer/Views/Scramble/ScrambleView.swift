//
//  ScrambleView.swift
//  cubeTimer
//
//  Created by Oleksii on 12.12.2024.
//

import SwiftUI
import Foundation

struct ScrambleView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var Updater = mainDataUpdater()
    @StateObject private var themeManager = ThemeManager.shared
    @ObservedObject private var inspectionData = InspectionData.shared
    
    @StateObject var stopWatch: StopWatch = StopWatch()
    
    @State var inspectionTimeRemaining: TimeInterval = 15
    let inspectionTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var inspectionRunning = false
    
    @State private var scramble: String = ""
    @State private var StopWatchPosition: CGPoint = .zero
    
    @State private var selectedPuzzle: Discipline = .three {
        didSet {
            updateScramble()
        }
    }
    
    @State private var isClicked: Bool = false
    @State private var LaunchReady: Bool = false
    @State private var isPressing: Bool = false
    
    private var timerColor: Color {
        switch isClicked {
        case false: return .white
        case true:
            if LaunchReady {return .green}
            else if !isPressing {return .white}
            else {return .red}
        }
    }
    
    @State var timerColor2: Color = .white
    
    @State var currentAO5: Float = 0
    @State var currentAO12: Float = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [themeManager.currentTheme.bgcolor.color, themeManager.currentTheme.secondaryColor.color]), startPoint: UnitPoint(x: 0.5, y: 0.1), endPoint: UnitPoint(x: 0.5, y: 1.3))
            .ignoresSafeArea()
            VStack (spacing: 20) {
                PuzzleMenu(Puzzle: $selectedPuzzle, theme: $themeManager.currentTheme)
                
                Text(scramble)
                    .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 23))
                    .frame(maxWidth: 355)
                
                
                if !inspectionData.inspectionEnabled {
                    //stopwatch 1
                    VStack{
                        GeometryReader { geometry in
                            Button(action: {
                                if LaunchReady || stopWatch.isRunning {
                                    stopWatch.toggleStopwatch()
                                    if (!stopWatch.isRunning){
                                        saveSolveInfo()
                                        updateScramble()
                                        updateAO()
                                    }
                                    self.isClicked = false
                                    self.LaunchReady = false
                                }
                            }) {
                                ZStack{
                                    Text(String(format: "%.3f", stopWatch.runningTime))
                                        .frame(minWidth: 330, maxHeight: 500, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 60))
                                    averageInfoBlock()
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        let frame = geometry.frame(in: CoordinateSpace.local)
                                        StopWatchPosition = CGPoint(x: frame.midX, y: frame.midY)
                                    }
                            })
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + (geometry.size.height / 2 - StopWatchPosition.y / 2) - 160)
                            .foregroundColor(timerColor)
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.8)
                                    .onChanged({ _ in
                                        if !stopWatch.isRunning
                                        {self.isClicked = true}
                                        isPressing = true
                                    })
                                    .onEnded({ _ in
                                        if !stopWatch.isRunning{
                                            self.LaunchReady = true
                                            isPressing = false
                                        }
                                    })
                            )
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        if isPressing {
                                            isPressing = false
                                        }
                                    }
                            )
                            .animation(.easeInOut(duration: 0.07), value: isPressing)
                            .buttonStyle(TimerButtonStyle(theme: $themeManager.currentTheme))
                        }
                    }
                }
                else {
                    //stopwatch 2
                    VStack {
                        GeometryReader {geometry in
                            Button(action: {
                                if !stopWatch.isRunning && !LaunchReady {
                                    LaunchReady = true
                                    inspectionRunning = true
                                    timerColor2 = .red
                                } else if !stopWatch.isRunning && LaunchReady {
                                    LaunchReady = false
                                    inspectionRunning = false
                                    inspectionTimeRemaining = 15
                                    
                                    stopWatch.toggleStopwatch()
                                    timerColor2 = .white
                                } else if stopWatch.isRunning {
                                    stopWatch.toggleStopwatch()
                                    if (!stopWatch.isRunning) {
                                        saveSolveInfo()
                                        updateScramble()
                                        updateAO()
                                    }
                                }
                            }) {
                                ZStack {
                                    Text("\(inspectionRunning ? String(format: "%.0f", inspectionTimeRemaining) : String(format: "%.3f", stopWatch.runningTime))")
                                        .foregroundColor(timerColor2)
                                        .frame(minWidth: 330, maxHeight: 500, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 60))
                                        .onReceive(inspectionTimer) { _ in
                                            if LaunchReady {
                                                if inspectionTimeRemaining > 0 {
                                                    inspectionTimeRemaining -= 1
                                                } else if inspectionTimeRemaining == 0 {
                                                    inspectionRunning = false
                                                    LaunchReady = false
                                                    inspectionTimeRemaining = 15
                                                    
                                                    stopWatch.toggleStopwatch()
                                                    timerColor2 = .white
                                                }
                                            }
                                        }
                                    averageInfoBlock()
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        let frame = geometry.frame(in: CoordinateSpace.local)
                                        StopWatchPosition = CGPoint(x: frame.midX, y: frame.midY)
                                    }
                            })
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + (geometry.size.height / 2 - StopWatchPosition.y / 2) - 160)
                            .animation(.easeInOut(duration: 0.07), value: isPressing)
                            .buttonStyle(TimerButtonStyle(theme: $themeManager.currentTheme))
                        }
                    }
                    //stopwatch 2
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            if scramble == "" {
                updateScramble()
            }
            updateAO()
            
        }
        .onChange(of: selectedPuzzle, perform: { _ in
            updateScramble()
            updateAO()
        })
        
    }
    
    private func updateScramble() {
        scramble = Updater.getScramble(selectedPuzzle)
    }
    
    private func updateAO() {
        dataManager.getCurrentAO(selectedPuzzle) { (ao5, ao12) in
            currentAO5 = ao5
            currentAO12 = ao12
        }
    }
    
    private func saveSolveInfo() {
        dataManager.saveSolve(date: .now, result: Float(stopWatch.runningTime), scramble: self.scramble, discipline: selectedPuzzle) { _ in
            DispatchQueue.main.async {
                dataManager.solvesCount += 1 // s
            }
            dataManager.updRecords { _ in }
        }
    }
    
    private func averageInfoBlock() -> some View {
        HStack {
            VStack {
                Text("AO5: ")
                Text(String(format: "%.3f", currentAO5))
            }
            .padding()
            VStack {
                Text("AO12: ")
                Text(String(format: "%.3f", currentAO12))
            }
            .padding()
        }
        .offset(y: 80)
        .font(.system(size: 20))
        .foregroundColor(themeManager.currentTheme.thirdColor.color)
    }
}

struct ScrambleView_Previews: PreviewProvider {
    static var previews: some View {
        ScrambleView().environmentObject(DataManager.shared)
    }
}

extension Binding {
    func didSet(_ didSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }
}
