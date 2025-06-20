//
//  Scramble_four.swift
//  cubeTimer
//
//  Created by Oleksii on 25.12.2024.
//

final public class Scramble_four: Scramble{
    
    override public var scrambleSequence: String {
        get{
            return generateScramble()
        }
        set {}
    }

    init(length scrambleLength: Int) {
        super.init(length: scrambleLength, moves: ["U", "D", "L", "R", "F", "B", "Rw", "Fw", "Uw", "Bw", "Lw", "Dw"])
    }
    
    override func checkPatterns2(move: String) -> Bool {
        return true
    }
}
