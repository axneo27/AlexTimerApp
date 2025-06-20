//
//  ScrambleMatrixGenerator.swift
//  cubeTimer
//
//  Created by Oleksii on 11.05.2025.
//

import SwiftUI

class ScrambleMatrixGenerator: ObservableObject {
    private var discipline: Discipline = .three
    
    public var cubeVertices: [[Color?]] = [[Color?]](
        repeating: [Color?](repeating: .black.opacity(0.0), count: 0),
     count: 0
    )
    
    private var scramble: String = ""
    
    public var gridWidth: Int = 0
    public var gridHeight: Int = 0
    public var cubeWH: Int = 0
    
    init(dis: Discipline, sc: String) {
        self.scramble = sc
        self.discipline = dis
        
        setGridWidthHeight()
        cubeWH = gridWidth / 4
        cubeVertices = [[Color?]](
            repeating: [Color?](repeating: .black.opacity(0.0), count: gridWidth),
         count: gridHeight
        )
        
        initializeCubeVerteces()
        scrambleCube()
    }
    
    private func scrambleCube() {
        let allMoves: [String] = scramble.components(separatedBy: " ")
        for move in allMoves {
            switch move {
            case "R":
                R()
            case "U":
                U()
            case "F":
                F()
            case "L":
                L()
            case "D":
                D()
            case "B":
                B()
                
            case "R'":
                R1()
            case "U'":
                U1()
            case "F'":
                F1()
            case "L'":
                L1()
            case "D'":
                D1()
            case "B'":
                B1()
            
            case "R2":
                R2()
            case "U2":
                U2()
            case "F2":
                F2()
            case "L2":
                L2()
            case "D2":
                D2()
            case "B2":
                B2()

            case "Rw":
                Rw()
            case "Rw'":
                Rw1()
            case "Rw2":
                Rw2()
            
            case "Lw":
                Lw()
            case "Lw'":
                Lw1()
            case "Lw2":
                Lw2()
            
            case "Uw":
                Uw()
            case "Uw'":
                Uw1()
            case "Uw2":
                Uw2()
                
            case "Dw":
                Dw()
            case "Dw'":
                Dw1()
            case "Dw2":
                Dw2()
                
            case "Fw":
                Fw()
            case "Fw'":
                Fw1()
            case "Fw2":
                Fw2()
                
            case "Bw":
                Bw()
            case "Bw'":
                Bw1()
            case "Bw2":
                Bw2()
                
            default:
                break
            }
        }
    }
    
    private func setGridWidthHeight() -> Void {
        switch self.discipline {
        case .two:
            gridWidth = 8
            gridHeight = 6
        case .three:
            gridWidth = 12
            gridHeight = 9
        case .four:
            gridWidth = 16
            gridHeight = 12
        case .five:
            gridWidth = 20
            gridHeight = 15
        default:
            gridWidth = 12
            gridHeight = 9
        }
    }
    
    private func initializeCubeVerteces() {
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i + cubeWH][j] = .orange
                cubeVertices[i][j + cubeWH] = .white
                cubeVertices[i + cubeWH][j + cubeWH] = .green
                cubeVertices[i + cubeWH][j + cubeWH*2] = .red
                cubeVertices[i + cubeWH][j + cubeWH*3] = .blue
                cubeVertices[i + cubeWH*2][j + cubeWH] = .yellow
            }
        }
    }
}
