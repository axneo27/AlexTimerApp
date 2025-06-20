//
//  RecordInfo.swift
//  cubeTimer
//
//  Created by Oleksii on 14.03.2025.
//

import Foundation
import SwiftUI

struct RecordInfoBlock: View {
    @Binding var result: Float
    @Binding var date: Date
    @Binding var solves: [Solve]
    @Binding var theme: Theme
    
    @Binding var someScrambleShowing: Bool
    @Binding var shownScramble: String
    @Binding var shownDiscipline: Discipline
    
    @State var type: String
    
    @State private var isSelecting: Bool = false
    
    var body: some View {
        VStack {
            VStack(spacing: 7) {
                HStack {
                    Text("Best \(type): ")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                    Text(formatResult(result))
                        .foregroundColor(.red)
                        .font(.system(size: 22))
                }
                
                HStack {
                    Text("Date: ")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                    Text(date, format: Date.FormatStyle()
                        .day(.twoDigits)
                        .month(.twoDigits)
                        .year(.defaultDigits)
                        .hour(.twoDigits(amPM: .omitted))
                        .minute(.twoDigits)
                        .locale(Locale(identifier: "en_GB"))) //does not help
                    
                        .foregroundColor(.orange)
                        .font(.system(size: 22))
                }
                
                HStack {
                    Image(systemName: isSelecting ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isSelecting ? 0 : 360))
                        .animation(.easeInOut(duration: 0.3), value: isSelecting)
                    Text(isSelecting ? "Hide Solves" : "Show Solves")
                        .foregroundColor(.orange)
                        .font(.system(size: 22))
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSelecting.toggle()
                    }
                }
//                .animation(.easeInOut, value: isSelecting)
            }
            .padding()
            .background(theme.bgcolor.color.opacity(0.4))
            .cornerRadius(10)
            
            if isSelecting {
                RecordSolves(solvesArray: solves, theme: $theme, someScrambleShowing: $someScrambleShowing, shownScramble: $shownScramble, shownDiscipline: $shownDiscipline)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isSelecting)
    }
    
    private func formatResult(_ v: Float) -> String {
        return String(format: "%.3f", v)
    }
}

struct RecordSolves: View {
    var solvesArray: [Solve]
    @Binding var theme: Theme
    @Binding var someScrambleShowing: Bool
    @Binding var shownScramble: String
    @Binding var shownDiscipline: Discipline
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(solvesArray, id: \.id) { solve in
                    VStack {
                        Group {
                            HStack {
                                VStack {
                                    Text("Scramble: ")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                    Button("Show scramble visual", action: {
                                        if (!someScrambleShowing) {
                                            someScrambleShowing = true
                                            shownScramble = solve.scramble ?? ""
                                            shownDiscipline = Puzzlenames.getByString(solve.discipline ?? "3x3") ?? .three
                                        }
                                    })
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.capsule)
                                    .tint(theme.secondaryColor.color)
                                }
                                Text(solve.scramble!)
                                    .foregroundColor(.orange)
                                    .font(.system(size: 18))
                            }
                            HStack {
                                Text("Date: ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                Text(solve.date!, format: Date.FormatStyle()
                                    .day(.twoDigits)
                                    .month(.twoDigits)
                                    .year(.defaultDigits)
                                    .hour(.twoDigits(amPM: .omitted))
                                    .minute(.twoDigits)
                                    .locale(Locale(identifier: "en_GB")))
                                
                                    .foregroundColor(.orange)
                                    .font(.system(size: 18))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(theme.bgcolor.color)
                        .cornerRadius(8)
                        
                        
                    }
                    .background(theme.bgcolor.color.opacity(0.4))
                    .cornerRadius(8)
                    .frame(maxWidth: 320)
                }
            }
        }
        .background(Color.clear)
        .frame(maxWidth: 320)
    }
}
