//
//  ScrambleMatrixGenerator+3x3.swift
//  cubeTimer
//
//  Created by Oleksii on 11.05.2025.
//
import SwiftUI

extension ScrambleMatrixGenerator { // 3x3
    func R() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[i][cubeWH*2 - 1])
            cubeVertices[i][cubeWH*2 - 1] = cubeVertices[i + cubeWH][cubeWH*2 - 1]
            
            swap(&temp[i], &cubeVertices[cubeWH*2 - 1 - i][cubeWH*3])
            swap(&temp[i], &cubeVertices[cubeWH*2 + i][cubeWH*2 - 1])
            
            cubeVertices[cubeWH + i][cubeWH*2 - 1] = temp[i]
        }
        
        //rotate side
        var oldSide = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        var newSide = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                oldSide[i][j] = cubeVertices[i + cubeWH][j + cubeWH*2]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                newSide[i][j] = oldSide[cubeWH - j - 1][i]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i + cubeWH][j + cubeWH*2] = newSide[i][j]
            }
        }
    }
    
   func R1() {
        for _ in 0..<3 {
            R()
        }
    }
    
    func R2() {
        for _ in 0..<2 {
            R()
        }
    }
    
    func L() {
        for _ in 0..<3 {
            L1()
        }
    }
    
    func L1() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[i][cubeWH])
            cubeVertices[i][cubeWH] = cubeVertices[cubeWH + i][cubeWH]
            
            swap(&temp[i], &cubeVertices[cubeWH*2 - 1 - i][cubeWH*4 - 1])
            swap(&temp[i], &cubeVertices[cubeWH*2 + i][cubeWH])
            cubeVertices[cubeWH + i][cubeWH] = temp[i]
        }
        
        //rotate side
        var oldSide = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        var newSide = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                oldSide[i][j] = cubeVertices[i + cubeWH][j]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                newSide[i][j] = oldSide[j][cubeWH - i - 1]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i + cubeWH][j] = newSide[i][j]
            }
        }
    }
    
    func L2() {
        for _ in 0..<2 {
            L()
        }
    }
    
    func U() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH][i])
        }
        for j in 0...cubeWH*3 - 1 {
            cubeVertices[cubeWH][j] = cubeVertices[cubeWH][j + cubeWH]
        }
        for i in 0..<cubeWH {
            cubeVertices[cubeWH][i + cubeWH*3] = temp[i]
        }
        
        //rotate top
        var oldTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        var newTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH{
                oldTop[i][j] = cubeVertices[i][j + cubeWH]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                newTop[i][j] = oldTop[cubeWH - j - 1][i]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i][j + cubeWH] = newTop[i][j]
            }
        }
        
    }
    
    func U1() {
        for _ in 0..<3 {
            U()
        }
    }
    
    func U2() {
        for _ in 0..<2 {
            U()
        }
    }
    
    func D1() {
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH*2 - 1][i])
        }
        for j in 0...cubeWH*3 - 1 {
            cubeVertices[cubeWH*2 - 1][j] = cubeVertices[cubeWH*2 - 1][j + cubeWH]
        }
        for i in 0..<cubeWH {
            cubeVertices[cubeWH*2 - 1][cubeWH*3 + i] = temp[i]
        }
        
        //rotate bottom
        var oldTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        var newTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                oldTop[i][j] = cubeVertices[i + cubeWH*2][j + cubeWH]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                newTop[i][j] = oldTop[j][cubeWH - i - 1]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i + cubeWH*2][j + cubeWH] = newTop[i][j]
            }
        }
        
    }
    
    func D() {
        for _ in 0..<3 {
            D1()
        }
    }
    
    func D2() {
        for _ in 0..<2 {
            D1()
        }
    }
    
    func F() {
        //rotate front
        var oldTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        var newTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                oldTop[i][j] = cubeVertices[i + cubeWH][j + cubeWH]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                newTop[i][j] = oldTop[cubeWH - j - 1][i]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i + cubeWH][j + cubeWH] = newTop[i][j]
            }
        }
        
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH*2][cubeWH+i])
            cubeVertices[cubeWH*2][cubeWH + i] = cubeVertices[cubeWH*2 - 1 - i][cubeWH*2]
            
            swap(&temp[i], &cubeVertices[cubeWH + i][cubeWH - 1])
            swap(&temp[i], &cubeVertices[cubeWH - 1][cubeWH*2 - 1 - i])
            cubeVertices[cubeWH*2 - 1 - i][cubeWH*2] = temp[i]
        }
    }
    
    func F1() {
        for _ in 0..<3 {
            F()
        }
    }
    
    func F2() {
        for _ in 0..<2 {
            F()
        }
    }
    
    func B1() {
        //rotate back
        var oldTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        var newTop = [[Color?]](
            repeating: [Color?](repeating: .black, count: cubeWH),
         count: cubeWH
        )
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                oldTop[i][j] = cubeVertices[i + cubeWH][j + cubeWH*3]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                newTop[i][j] = oldTop[j][cubeWH - i - 1]
            }
        }
        
        for i in 0..<cubeWH {
            for j in 0..<cubeWH {
                cubeVertices[i + cubeWH][j + cubeWH*3] = newTop[i][j]
            }
        }
        
        var temp: [Color?] = []
        for i in 0..<cubeWH {
            temp.append(cubeVertices[cubeWH*3 - 1][i + cubeWH])
            cubeVertices[cubeWH*3 - 1][i + cubeWH] = cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 - 1]
            swap(&temp[i], &cubeVertices[cubeWH + i][0])
            swap(&temp[i], &cubeVertices[0][cubeWH*2 - 1 - i])
            cubeVertices[cubeWH*2 - 1 - i][cubeWH*3 - 1] = temp[i]
        }
        
    }
    
    func B() {
        for _ in 0..<3 {
            B1()
        }
    }
    
    func B2() {
        for _ in 0..<2 {
            B1()
        }
    }
}
