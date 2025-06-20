//
//  MockCoreDataFactory.swift
//  cubeTimer
//
//  Created by Oleksii on 09.04.2025.
//

import CoreData

class MockCoreDataFactory {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createSolve(date: Date, result: Float, scramble: String, discipline: Discipline) -> Solve {
        let newSolve = Solve(context: self.context)
        newSolve.discipline = Puzzlenames[discipline]
        newSolve.result = result
        newSolve.date = date
        newSolve.scramble = scramble
        newSolve.id = UUID()
        return newSolve
    }
}
