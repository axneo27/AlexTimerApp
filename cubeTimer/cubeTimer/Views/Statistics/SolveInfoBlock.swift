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
    
    private let result: Float
    private let scramble: String
    private let discipline: String
    private let date: Date
    private let id: UUID
    
    init(solveDate: Date, solveDiscipline: String, solveResult: Float, solveScramble: String, solveID: UUID) {
        self.date = solveDate
        self.discipline = solveDiscipline
        self.result = solveResult
        self.scramble = solveScramble
        self.id = solveID
    }
    
    var body: some View {
        VStack(spacing: 0) { // added vstack
            HStack {
                ChevronIcon(isSelecting: $isSelecting)
                
                Spacer().frame(width: 16)
                
                Text(String(format: "%.2f", result))
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
                                   ))
                }
                .transition(.opacity)
                .offset(y: 8)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isSelecting)
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
    let item: String
    
    var body: some View {
        Button {
            withAnimation {
                isSelecting = false
            }
        } label: {
            HStack {
                Text(item)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                Spacer()
            }
            .padding(.horizontal)
            .foregroundColor(.white)
        }
    }
}
