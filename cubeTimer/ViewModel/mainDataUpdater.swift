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
    
    @Published private var scramblesWCA: [Discipline: [String]] =
    [.two : [],
     .three: [],
     .four: [],
     .five: [],
     .six: []]
    @Published private var successfullAPIconnection: Bool = false
    
    public func getScramble(_ discipline: Discipline) -> String {
        if scramblesWCA[discipline]!.isEmpty {
            DispatchQueue.global(qos: .utility).async {
                self.getScrambleAPI(discipline) { newScrambles in
                    print(newScrambles ?? "nil in api")
                    print(self.scramblesWCA[discipline]!.count)
                }
            }
            return getScrambleLocally(discipline)
        } else {
            return scramblesWCA[discipline]!.removeLast()
        }
    }
    
    private func getScrambleAPI(_ discipline: Discipline, completion: @escaping ([String]?) -> Void) -> Void {
        if discipline == .five || discipline == .six {
            self.successfullAPIconnection = false
            completion(nil)
            return
        }
        let requestMaker: RequestMaker = RequestMaker(puzzleType: discipline, count: 5)
        
        requestMaker.getScramblesString{ scrambleArray in
            if let scrambles = scrambleArray {
                self.scramblesWCA[discipline]! = scrambles
                self.successfullAPIconnection = false
                
                completion(scrambleArray)
            } else {
                completion(nil)
            }
        }
    }
    
    private func getScrambleLocally(_ discipline: Discipline) -> String {
        switch discipline{
        case .two: return Scramble_two(length: 9).scrambleSequence
        case .three: return Scramble_three(length: 24).scrambleSequence
        case .four: return Scramble_four(length: 46).scrambleSequence
        case .five: return Scramble_five(length: 60).scrambleSequence
        case .six: return Scramble_six(length: 80).scrambleSequence
        case .all: return "none"
        }
    }
}
