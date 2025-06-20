//
//  Scramble_three.swift
//  cubeTimer
//
//  Created by Oleksii on 23.12.2024.
//

import Foundation

final public class Scramble_three: Scramble{
    
    override public var scrambleSequence: String {
        get{
            return generateScramble()
        }
        set {}
    }

    init(length scrambleLength: Int) {
        super.init(length: scrambleLength, moves: ["U", "D", "L", "R", "F", "B"])
    }
}
