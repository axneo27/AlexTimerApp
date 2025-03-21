//
//  SolveInfoBlock.swift
//  cubeTimer
//
//  Created by Oleksii on 12.01.2025.
//

import Foundation
import SwiftUI

struct SolveInfoBlock : View {
    @State private var result: Float
    @State private var scramble: String
    @State private var discipline: String
    @State private var date: Date
    @State private var id: UUID
    
    @State private var isSelecting: Bool = false
    
    init(solveDate: Date, solveDiscipline: String, solveResult: Float, solveScramble: String, solveID: UUID) {
        _date = State.init(initialValue: solveDate)
        _discipline = State.init(initialValue: solveDiscipline)
        _result = State.init(initialValue: solveResult)
        _scramble = State.init(initialValue: solveScramble)
        _id = State.init(initialValue: solveID)
    }
    
    var body : some View {
        HStack {
            Image(systemName: isSelecting ? "chevron.up" : "chevron.down")
                .foregroundColor(.white)
                .rotationEffect(.degrees(isSelecting ? 0 : 360))
                .animation(.easeInOut(duration: 0.3), value: isSelecting)
            Rectangle().fill(.clear)
                .frame(height: 30)
                .contentShape(Rectangle())
            Text(String(result))
                .foregroundColor(.white)
                .font(.system(size: 25))
            Text(discipline)
                .foregroundColor(.white)
                .font(.system(size: 25))
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isSelecting.toggle()
            }
        }
        .animation(.easeInOut, value: isSelecting)
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            Color.clear.overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                        .frame(height: 1)
                },
                alignment: .bottom
            )
        )
        if isSelecting {
            VStack(spacing: 5) {
                DropdownInfoItem(isSelecting: $isSelecting, item: scramble)
                DropdownInfoItem(isSelecting: $isSelecting, item: date.toString(dateFormat: "dd-MMM-yyyy hh:mm a"))
            }
        }
    }
}

struct DropdownInfoItem: View {
    @Binding var isSelecting: Bool

    let item: String

    var body: some View {
        Button(action: {
            isSelecting = false
        }) {
            HStack {
                Text(item)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                Spacer()
            }
            .padding(.horizontal)
            .foregroundColor(.white)
            .animation(.easeInOut, value: isSelecting)
        }
    }
}
