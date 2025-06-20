//
//  ScrambleMatrixGenerator+4x4.swift
//  cubeTimer
//
//  Created by Oleksii on 12.05.2025.
//

import SwiftUI

extension ScrambleMatrixGenerator { // 4x4
    func Rw() {
        R()
        
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[i][cubeWH*2 - 2])
            cubeVertices[i][cubeWH*2 - 2] = cubeVertices[i + cubeWH][cubeWH*2 - 2]

            swap(&temp[i], &cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 + 1])
            swap(&temp[i], &cubeVertices[cubeWH*2 + i][cubeWH*2 - 2])
          
            cubeVertices[cubeWH + i][cubeWH*2 - 2] = temp[i]
        }
    }
    
    func Rw1() {
        for _ in 0..<3 {
            Rw()
        }
    }
    
    func Rw2() {
        for _ in 0..<2 {
            Rw()
        }
    }
    
    func Lw() {
        for _ in 0..<3 {
            Lw1()
        }
    }
    
    func Lw1() {
        L1()
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[i][cubeWH + 1])
            cubeVertices[i][cubeWH + 1] = cubeVertices[cubeWH + i][cubeWH + 1]
            
            swap(&temp[i], &cubeVertices[cubeWH*2 - 1 - i][cubeWH*4 - 2])
            swap(&temp[i], &cubeVertices[cubeWH*2 + i][cubeWH + 1])
            cubeVertices[cubeWH + i][cubeWH + 1] = temp[i]
        }
    }
    
    func Lw2() {
        for _ in 0..<2 {
            Lw1()
        }
    }
    
    func Uw() {

        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH + 1][i])
        }
        for j in 0...cubeWH*3 - 1 {
            cubeVertices[cubeWH + 1][j] = cubeVertices[cubeWH][j + cubeWH]
        }
        for i in 0..<cubeWH {
            cubeVertices[cubeWH + 1][i + cubeWH*3] = temp[i]
        }
        U()
    }
    
    func Uw1() {
        for _ in 0..<3 {
            Uw()
        }
    }
    
    func Uw2() {
        for _ in 0..<2 {
            Uw()
        }
    }
    
    func Dw() {
        for _ in 0..<3 {
            Dw1()
        }
    }
    
    func Dw1() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH*2 - 2][i])
        }
        for j in 0...cubeWH*3 - 1 {
            cubeVertices[cubeWH*2 - 2][j] = cubeVertices[cubeWH*2 - 2][j + cubeWH]
        }
        for i in 0..<cubeWH {
            cubeVertices[cubeWH*2 - 2][cubeWH*3 + i] = temp[i]
        }
        D1()
    }
    
    func Dw2() {
        for _ in 0..<2 {
            Dw1()
        }
    }
    
    func Fw() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH*2 + 1][cubeWH+i])
            cubeVertices[cubeWH*2 + 1][cubeWH + i] = cubeVertices[cubeWH*2 - 1 - i][cubeWH*2 + 1]
            
            swap(&temp[i], &cubeVertices[cubeWH + i][cubeWH - 2])
            swap(&temp[i], &cubeVertices[cubeWH - 2][cubeWH*2 - 1 - i])
            cubeVertices[cubeWH*2 - 1 - i][cubeWH*2 + 1] = temp[i]
        }
        F()
    }
    
    func Fw1() {
        for _ in 0..<3 {
            Fw()
        }
    }
    
    func Fw2() {
        for _ in 0..<2 {
            Fw()
        }
    }
    
    func Bw1() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH*3 - 2][i + cubeWH])
            cubeVertices[cubeWH*3 - 2][i + cubeWH] = cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 - 2]
            swap(&temp[i], &cubeVertices[cubeWH + i][1])
            swap(&temp[i], &cubeVertices[1][cubeWH*2 - 1 - i])
            cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 - 2] = temp[i]
        }
        B1()
    }
    
    func Bw() {
        for _ in 0..<3 {
            Bw1()
        }
    }
    
    func Bw2() {
        for _ in 0..<2 {
            Bw1()
        }
    }
}
