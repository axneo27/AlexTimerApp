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
    @State var is3d: Bool = false
    
    @StateObject private var themeManager = ThemeManager.shared
    @ObservedObject private var scrambleMatrixGenerator: ScrambleMatrixGenerator
    
    public var gridWidth: Int = 0
    public var gridHeight: Int = 0
    public var cubeWH: Int = 0
    
    public init(discipline: Binding<Discipline>, scramble: Binding<String>, _ isShowing: Binding<Bool>) {
        self._scramble = scramble
        self._discipline = discipline
        scrambleMatrixGenerator = .init(dis: discipline.wrappedValue, sc: scramble.wrappedValue)
        self._isShowing = isShowing
    }
    
    public var maxW: CGFloat = 310
    public var maxH: CGFloat = 230
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                ZStack {
                    if is3d {
                        Grid3D()
                    } else {
                        Grid2D()
                    }
                }
                .frame(maxHeight: maxH)
                .frame(maxWidth: maxW)
                .animation(.easeInOut(duration: 0.3), value: is3d)
                
                HStack(spacing: 16) {
                    Button("2D") { is3d = false }
                        .opacity(is3d ? 0.7 : 1)
                    Button("3D") { is3d = true }
                        .opacity(is3d ? 1 : 0.7)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .foregroundStyle(.white)
                .tint(themeManager.currentTheme.secondaryColor.color)
                .animation(.easeInOut(duration: 0.2), value: is3d)
            }
            .padding(.top, 24)
            .padding(12)
            
            Button(action: { isShowing = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(themeManager.currentTheme.secondaryColor.color)
                    .padding(8)
            }
        }
        .background(Color.black)
        .cornerRadius(12)
    }
    
    private func Grid2D() -> some View {
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
    }
    
    private func Grid3D() -> some View {
        CubeScramble3DView(cv: $scrambleMatrixGenerator.cubeVertices)
    }
}

#Preview {
    struct Preview: View {
        @State var scramble = "R U R' U'"
        @State var discipline: Discipline = .three
        @State var isShowing: Bool = true
        var body: some View {
            ScrambleGrid(discipline: $discipline, scramble: $scramble, $isShowing)
        }
    }

    return Preview()
}
