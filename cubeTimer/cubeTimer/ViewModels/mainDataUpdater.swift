//
//  mainDataUpdater.swift
//  cubeTimer
//
//  Created by Oleksii on 30.12.2024.
//

import Foundation
import SwiftUI

final class mainDataUpdater : ObservableObject{
    @Published public var stopWatch: StopWatch = StopWatch()
    @AppStorage("inspectionEnabled") var isInspectionEnabled: Bool = false
    
    @Published private var scramblesWCA: [Discipline: [String]] = [.two : [],
                                                                   .three: [],
                                                                   .four: []]
    @Published private var successfullAPIconnection: Bool = false
    
    public func getScramble(_ discipline: Discipline) -> String{
        if scramblesWCA[discipline]!.count == 0 {
            self.successfullAPIconnection = getScrambleAPI(discipline)
            return getScrambleLocally(discipline)
        } else {
            return scramblesWCA[discipline]!.removeLast()
        }
    }
    
    private func getScrambleAPI(_ discipline: Discipline) -> Bool {
        let requestMaker: RequestMaker = RequestMaker(puzzleType: discipline, count: 10)
        var result: Bool = false
        requestMaker.getScramblesString{ scrambleArray in
            if let scrambles = scrambleArray {
                for i in 0..<scrambles.count {
                    self.scramblesWCA[discipline]!.append(scrambles[i])
                }
                result = true
            }
        }
        return result
    }
    
    private func getScrambleLocally(_ discipline: Discipline) -> String {
        switch discipline{
        case .two: return Scramble_two(length: 9).scrambleSequence
        case .three: return Scramble_three(length: 24).scrambleSequence
        case .four: return Scramble_four(length: 46).scrambleSequence
        case .all: return "none"
        }
    }
}

public struct Puzzlenames {
    static private var dict: [Discipline : String] = [
        .two: "2x2",
        .three: "3x3",
        .four: "4x4",
        .all: "All"
    ]
    
    static private var dict2: [String : Discipline] = [
        "2x2" : .two,
        "3x3" : .three,
        "4x4" : .four,
        "All" : .all
    ]
    
    static public subscript(discipline: Discipline) -> String? {
        get{ dict[discipline] }
    }
    
    static public func getByString(_ s: String) -> Discipline? {
        return dict2[s] ?? nil
    }
}// will change everywhere
