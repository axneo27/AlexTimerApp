//
//  ScrambleGrid.swift
//  cubeTimer
//
//  Created by Oleksii on 02.05.2025.
//
import SwiftUI

struct ScrambleGrid: View {
    @Binding var discipline: Discipline
    @Binding var scramble: String
    @Binding var isShowing: Bool
    
    @StateObject private var themeManager = ThemeManager.shared
    @ObservedObject private var scrambleMatrixGenerator: ScrambleMatrixGenerator
    
    public var gridWidth: Int = 0
    public var gridHeight: Int = 0
    public var cubeWH: Int = 0
    
    public var cubeVertices: [[Color?]] = [[Color?]](
        repeating: [Color?](repeating: .black.opacity(0.0), count: 0),
     count: 0
    )
    
    public init(discipline: Binding<Discipline>, scramble: Binding<String>, _ isShowing: Binding<Bool>) {
        self._scramble = scramble
        self._discipline = discipline
        scrambleMatrixGenerator = .init(dis: discipline.wrappedValue, sc: scramble.wrappedValue)
        self._isShowing = isShowing
    }
    
    public var maxW: CGFloat = 310
    public var maxH: CGFloat = 230
    
    var body: some View {
        VStack {
            Grid(horizontalSpacing: 0.5, verticalSpacing: 0.5) {
                ForEach(0..<scrambleMatrixGenerator.gridHeight, id: \.self) { rowIndex in
                    GridRow {
                        ForEach(0..<scrambleMatrixGenerator.gridWidth, id: \.self) { columnIndex in
                            scrambleMatrixGenerator.cubeVertices[rowIndex][columnIndex]
                                .cornerRadius(3)
                                .brightness(-0.08)
                        }
                    }
                }
            }
            .frame(maxHeight: maxH)
            .frame(maxWidth: maxW)
            
            Button("Hide", action: {
                isShowing = false
            })
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .foregroundStyle(.white)
            .tint(themeManager.currentTheme.secondaryColor.color)
        }
        .padding(8)
        .background(Color.black.opacity(0.9))
        .cornerRadius(8)
    }
}

#Preview {
    struct Preview: View {
        @State var scramble = ""
        @State var discipline: Discipline = .five
        @State var isShowing: Bool = false
        var body: some View {
            ScrambleGrid(discipline: $discipline, scramble: $scramble, $isShowing)
        }
    }

    return Preview()
}
