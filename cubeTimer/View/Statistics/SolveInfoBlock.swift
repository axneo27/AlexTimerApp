//
//  SolveInfoBlock.swift
//  cubeTimer
//
//  Created by Oleksii on 12.01.2025.
//

import Foundation
import SwiftUI

struct SolveInfoBlock: View {
    @State private var isSelecting: Bool = false
    @Binding var someScrambleShowing: Bool
    @Binding var shownScramble: String
    @Binding var shownDiscipline: Discipline
    
    private let result: Float
    private let scramble: String
    private let discipline: String
    private let date: Date
    private let id: UUID
    
    init(solveDate: Date, solveDiscipline: String, solveResult: Float, solveScramble: String, solveID: UUID, _ s: Binding<Bool>,
         _ sS: Binding<String>, _ sD: Binding<Discipline>) {
        self.date = solveDate
        self.discipline = solveDiscipline
        self.result = solveResult
        self.scramble = solveScramble
        self.id = solveID
        
        self._someScrambleShowing = s
        self._shownScramble = sS
        self._shownDiscipline = sD
    }
    
    var body: some View {
        VStack(spacing: 0) { // added vstack
            HStack {
                ChevronIcon(isSelecting: $isSelecting)
                
                Spacer().frame(width: 16)
                
                Text(String(format: "%.3f", result))
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                
                Text(discipline)
                    .foregroundColor(.white)
                    .font(.system(size: 25))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture {
                isSelecting.toggle()
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color(white: 0.96))
                    .offset(y: 8)
            }
            
            if isSelecting {
                VStack(spacing: 5) {
                    DropdownInfoItem(isSelecting: $isSelecting, item: scramble)
                    DropdownInfoItem(isSelecting: $isSelecting,
                                   item: date.formatted( //changed here
                                       .dateTime
                                           .day(.twoDigits)
                                           .month(.twoDigits)
                                           .year(.defaultDigits)
                                           .hour(.twoDigits(amPM: .omitted))
                                           .minute(.twoDigits)
                                           .locale(Locale(identifier: "en_GB"))
                                   ))
                    DropdownInfoItem(isSelecting: $isSelecting, viewItem:
                        AnyView(
                            Button("Show scramble visual", action: {
                                if (!someScrambleShowing) {
                                    someScrambleShowing = true
                                    shownScramble = scramble
                                    shownDiscipline = Puzzlenames.getByString(discipline) ?? .three
                                }
                            })
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .tint(.black)
                        )
                )}
                .transition(.move(edge: .top).combined(with: .opacity))
                .offset(y: 8)
                .padding()
            }
        }
    }
}

struct ChevronIcon: View {
    @Binding var isSelecting: Bool
    
    var body: some View {
        Image(systemName: isSelecting ? "chevron.up" : "chevron.down")
            .foregroundColor(.white)
            .rotationEffect(.degrees(isSelecting ? 0 : 360))
    }
}

struct DropdownInfoItem: View {
    @Binding var isSelecting: Bool
    var item: String? = nil
    var viewItem: AnyView? = nil
    
    init(isSelecting: Binding<Bool>, item: String? = nil, viewItem: AnyView? = nil) {
        self._isSelecting = isSelecting
        self.item = item
        self.viewItem = viewItem
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isSelecting = false
            }
        } label: {
            HStack {
                if let item = item {
                    Text(item)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                    Spacer()
                }
                if let viewItem = viewItem {
                    viewItem
                    Spacer()
                }
            }
            .padding(.horizontal)
            .foregroundColor(.white)
        }
    }
}
