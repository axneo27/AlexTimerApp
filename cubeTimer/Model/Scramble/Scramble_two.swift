//
//  Scramble_two.swift
//  cubeTimer
//
//  Created by Oleksii on 23.12.2024.
//

final public class Scramble_two: Scramble{
    
    override public var scrambleSequence: String {
        get{
            return generateScramble()
        }
        set {}
    }

    init(length scrambleLength: Int) {
        super.init(length: scrambleLength, moves: ["U", "R", "F"])
    }
    
    override func checkPatterns(move: String) -> Bool{
        guard (scrambleArray.count + 1) % 2 == 0 else {return true}
        var newArr: [String] = scrambleArray
        newArr.append(move)
        for i in 0..<((newArr.count/2) - 1){
            var ar1: [String] = []
            var ar2: [String] = []
            for j in 0..<(i + 2) {
                ar2.append(newArr[newArr.count - 1 - j])
                ar1.append(newArr[newArr.count - 1 - j - (i + 2)])
            }
            if ar1==ar2 {return false}
        }
        return true
        
    }
    
    override func checkPatterns2(move: String) -> Bool {
        return true
    }
}
