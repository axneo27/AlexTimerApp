//
//  Scramble.swift
//  cubeTimer
//
//  Created by Oleksii on 23.12.2024.
//

import Foundation

protocol Puzzle{
    var possibleMoves : [String] { get }
}

protocol Schecks{
    func checkCancelling(_ moveBefore: String, _ moveAfter: String) -> Bool
    func checkPatterns(move: String) -> Bool
    func checkPatterns2(move: String) -> Bool
}

protocol Scrambling{
    func generateMove() -> String
    func generateScramble() -> String
}

struct AdditionalModifier {
    var value: String
    var weight: Double
    
    init(value: String, weight: Double) {
        self.value = value
        self.weight = weight
    }
}

public class Scramble: Puzzle, Schecks, Scrambling {
    
    public var possibleMoves: [String]
    
    var additionalModifiers: [AdditionalModifier]
    
    public var scrambleSequence: String = ""
    public var scrambleArray: [String] = []
    
    public var scrambleLength: Int = 0
    
    public var modifiers : [String] = ["", "'", "2"]
    
    init(length scrambleLength: Int, moves possibleMoves: [String], _ addModifs: [AdditionalModifier] = []) {
        self.scrambleLength = scrambleLength
        self.possibleMoves = possibleMoves
        self.additionalModifiers = addModifs
    }
    
    public func generateMove() -> String {
        let r = Int.random(in: 0..<possibleMoves.count)
        let r2 = Int.random(in: 0..<modifiers.count)
        
        var move = possibleMoves[r]
        
        if !additionalModifiers.isEmpty && move.count == 2 {
            let r_start = weightedRandom(modifiers: additionalModifiers)
            move = r_start + move
        }
        
        move+=modifiers[r2]
        
        if scrambleArray.count != 0{
            if !checkPatterns(move: move){return generateMove()}
            else if !checkCancelling(scrambleArray[scrambleArray.count - 1], move) {return generateMove()}
            else if !checkPatterns2(move: move) {return generateMove()}
        }
        scrambleArray.append(move)
        return move
    }

    public func generateScramble() -> String {
        var s: String = ""
        while scrambleArray.count != scrambleLength {
            let move = generateMove()
            s+=move+" "
        }
        return s
    }
    
    func checkCancelling(_ moveBefore: String, _ moveAfter: String) -> Bool {
        if moveBefore[0] != moveAfter[0] {return true}
        return false
    }
    
    func checkPatterns(move: String) -> Bool{
        guard (scrambleArray.count + 1) % 2 == 0 else {return true}
        var newArr: [String] = scrambleArray
        newArr.append(move)
        for i in 0..<((newArr.count/2) - 1){
            var ar1: [String] = []
            var ar2: [String] = []
            for j in 0..<(i + 2) {
                ar2.append(newArr[newArr.count - 1 - j][0])
                ar1.append(newArr[newArr.count - 1 - j - (i + 2)][0])
            }
            if ar1==ar2 {return false}
        }
        return true
    }
    
    func checkPatterns2(move: String) -> Bool {
        guard scrambleArray.count >= 2 else {return true}
        if move[0] == scrambleArray[scrambleArray.count - 2][0] {return false}
        return true
    }
    
    private func weightedRandom(modifiers: [AdditionalModifier]) -> String {
        let weights = modifiers.map { $0.weight }
        let choices = modifiers.map {$0.value}
        
        let random = Double.random(in: 0..<weights.reduce(0, +))
        var cumulativeWeight = 0.0

        for (index, weight) in weights.enumerated() {
            cumulativeWeight += weight
            if random < cumulativeWeight {
                return choices[index]
            }
        }
        return choices.last!
    }
}
