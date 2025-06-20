//
//  Puzzlenames.swift
//  cubeTimer
//
//  Created by Oleksii on 02.04.2025.
//

public struct Puzzlenames {
    static private var dict: [Discipline : String] = [
        .two: "2x2",
        .three: "3x3",
        .four: "4x4",
        .five: "5x5",
        .six: "6x6",
        .all: "All"
    ]
    
    static private var dict2: [String : Discipline] = [
        "2x2" : .two,
        "3x3" : .three,
        "4x4" : .four,
        "5x5" : .five,
        "6x6" : .six,
        "All" : .all
    ]
    
    static public subscript(discipline: Discipline) -> String? {
        get{ dict[discipline] }
    }
    
    static public func getByString(_ s: String) -> Discipline? {
        return dict2[s] ?? nil
    }
}// will change everywhere
