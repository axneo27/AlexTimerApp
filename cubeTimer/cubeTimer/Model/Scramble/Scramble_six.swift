//
//  Scramble_six.swift
//  cubeTimer
//
//  Created by Oleksii on 02.04.2025.
//

final public class Scramble_six: Scramble{
    
    override public var scrambleSequence: String {
        get{
            return generateScramble()
        }
        set {}
    }

    init(length scrambleLength: Int) {
        super.init(length: scrambleLength, moves: ["U", "D", "L", "R", "F", "B", "Rw", "Fw", "Uw", "Bw", "Lw", "Dw"],
                   [AdditionalModifier(value: "", weight: 0.7), AdditionalModifier(value: "3", weight: 0.3)])
    }
    
    override func checkPatterns2(move: String) -> Bool {
        return true
    }
}
