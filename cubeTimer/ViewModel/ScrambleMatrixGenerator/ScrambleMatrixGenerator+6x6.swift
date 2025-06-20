//
//  ScrambleMatrixGenerator+6x6.swift
//  cubeTimer
//
//  Created by Oleksii on 13.05.2025.
//

import SwiftUI

//extension ScrambleMatrixGenerator {
//    func _3Rw() {
//        Rw()
//        
//        var temp: [Color?] = []
//        for i in 0..<cubeWH {
//            temp.append(cubeVertices[i][cubeWH*2 - 3])
//            cubeVertices[i][cubeWH*2 - 3] = cubeVertices[i + cubeWH][cubeWH*2 - 3] // stopped here
//
//            swap(&temp[i], &cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 + 1])
//            swap(&temp[i], &cubeVertices[cubeWH*2 + i][cubeWH*2 - 2])
//          
//            cubeVertices[cubeWH + i][cubeWH*2 - 2] = temp[i]
//        }
//    }
//    
//    func _3Rw1() {
//        for _ in 0..<3 {
//            _3Rw()
//        }
//    }
//    
//    func _3Rw2() {
//        for _ in 0..<2 {
//            _3Rw()
//        }
//    }
//    
//    func _3Lw() {
//        for _ in 0..<3 {
//            _3Lw1()
//        }
//    }
//    
//    func _3Lw1() {
//        L1()
//        var temp: [Color?] = []
//        for i in 0..<cubeWH {
//            temp.append(cubeVertices[i][cubeWH + 1])
//            cubeVertices[i][cubeWH + 1] = cubeVertices[cubeWH + i][cubeWH + 1]
//            
//            swap(&temp[i], &cubeVertices[cubeWH*2 - 1 - i][cubeWH*4 - 2])
//            swap(&temp[i], &cubeVertices[cubeWH*2 + i][cubeWH + 1])
//            cubeVertices[cubeWH + i][cubeWH + 1] = temp[i]
//        }
//    }
//    
//    func _3Lw2() {
//        for _ in 0..<2 {
//            _3Lw1()
//        }
//    }
//    
//    func _3Uw() {
//
//        var temp: [Color?] = []
//        for i in 0..<cubeWH {
//            temp.append(cubeVertices[cubeWH + 1][i])
//        }
//        for j in 0...cubeWH*3 - 1 {
//            cubeVertices[cubeWH + 1][j] = cubeVertices[cubeWH][j + cubeWH]
//        }
//        for i in 0..<cubeWH {
//            cubeVertices[cubeWH + 1][i + cubeWH*3] = temp[i]
//        }
//        U()
//    }
//    
//    func _3Uw1() {
//        for _ in 0..<3 {
//            _3Uw()
//        }
//    }
//    
//    func _3Uw2() {
//        for _ in 0..<2 {
//            _3Uw()
//        }
//    }
//    
//    func _3Dw() {
//        for _ in 0..<3 {
//            _3Dw1()
//        }
//    }
//    
//    func _3Dw1() {
//        var temp: [Color?] = []
//        for i in 0..<cubeWH {
//            temp.append(cubeVertices[cubeWH*2 - 2][i])
//        }
//        for j in 0...cubeWH*3 - 1 {
//            cubeVertices[cubeWH*2 - 2][j] = cubeVertices[cubeWH*2 - 2][j + cubeWH]
//        }
//        for i in 0..<cubeWH {
//            cubeVertices[cubeWH*2 - 2][cubeWH*3 + i] = temp[i]
//        }
//        D1()
//    }
//    
//    func _3Dw2() {
//        for _ in 0..<2 {
//            _3Dw1()
//        }
//    }
//    
//    func _3Fw() {
//        var temp: [Color?] = []
//        for i in 0..<cubeWH {
//            temp.append(cubeVertices[cubeWH*2 + 1][cubeWH+i])
//            cubeVertices[cubeWH*2 + 1][cubeWH + i] = cubeVertices[cubeWH*2 - 1 - i][cubeWH*2 + 1]
//            
//            swap(&temp[i], &cubeVertices[cubeWH + i][cubeWH - 2])
//            swap(&temp[i], &cubeVertices[cubeWH - 2][cubeWH*2 - 1 - i])
//            cubeVertices[cubeWH*2 - 1 - i][cubeWH*2 + 1] = temp[i]
//        }
//        F()
//    }
//    
//    func _3Fw1() {
//        for _ in 0..<3 {
//            _3Fw()
//        }
//    }
//    
//    func _3Fw2() {
//        for _ in 0..<2 {
//            _3Fw()
//        }
//    }
//    
//    func _3Bw1() {
//        var temp: [Color?] = []
//        for i in 0..<cubeWH {
//            temp.append(cubeVertices[cubeWH*3 - 2][i + cubeWH])
//            cubeVertices[cubeWH*3 - 2][i + cubeWH] = cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 - 2]
//            swap(&temp[i], &cubeVertices[cubeWH + i][1])
//            swap(&temp[i], &cubeVertices[1][cubeWH*2 - 1 - i])
//            cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 - 2] = temp[i]
//        }
//        B1()
//    }
//    
//    func _3Bw() {
//        for _ in 0..<3 {
//            _3Bw1()
//        }
//    }
//    
//    func _3Bw2() {
//        for _ in 0..<2 {
//            _3Bw1()
//        }
//    }
//}
