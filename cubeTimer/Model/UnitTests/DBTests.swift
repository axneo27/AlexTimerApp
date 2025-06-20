//
//  DBTests.swift
//  cubeTimerTests
//
//  Created by Oleksii on 09.04.2025.
//

import XCTest
import CoreData
@testable import cubeTimer

final class DBTests: XCTestCase {
    var coreDataManager: DataManager!
    var persistentContainer: NSPersistentContainer!
    var factory: MockCoreDataFactory!
    
    override func setUp() {
        super.setUp()
        persistentContainer = TestCoreDataStack().persistentContainer
        coreDataManager = DataManager(container: persistentContainer)
        factory = MockCoreDataFactory(context: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        resetAllManagedObjectContexts()
        persistentContainer = nil
        coreDataManager = nil
        factory = nil
        super.tearDown()
    }
    
    func testGetAvgLastWithNotEnoughSolves() {
        let solve = factory.createSolve(date: Date(), result: 10.0, scramble: "111111", discipline: .three)
        coreDataManager.byDiscipline[.three] = [solve]
        try? persistentContainer.viewContext.save()
        
        XCTAssertNil(coreDataManager.getAvgLast(from: .three, 5))
    }
    
    private func saveMultipleSolves(_ solves: [Solve], completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            do {
                for solve in solves {
                    let newSolve = Solve(context: context)
                    newSolve.date = solve.date
                    newSolve.result = solve.result
                    newSolve.scramble = solve.scramble
                    newSolve.discipline = solve.discipline
                }
                
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    XCTFail("Failed to save solves: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func testGetAvgLast() throws {
        let now = Date()
        let solves = [
            factory.createSolve(date: now.addingTimeInterval(-500), result: 11.902, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-300), result: 12.902, scramble:"222222", discipline: .three),
            //
            factory.createSolve(date: now.addingTimeInterval(-240), result: 5.244, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-180), result: 8.212, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-120), result: 15.893, scramble:"222222",discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-60), result: 17.200, scramble:"222222", discipline: .three),
            factory.createSolve(date: now, result: 14.754, scramble:"222222", discipline: .three)
        ]
        
        coreDataManager.byDiscipline[.three] = solves
        
        try persistentContainer.viewContext.save()
        
        let result = try XCTUnwrap(coreDataManager.getAvgLast(from: .three, 5)) //
        
        XCTAssertEqual(result.0, 12.953, accuracy: 0.001, "Incorrect average calculation")
        
        XCTAssertEqual(result.1.count, 5, "Should return exactly 5 solves")
    }
    
    func testgetAvgBest() throws {
        let now = Date()
        let solves = [
            factory.createSolve(date: now.addingTimeInterval(-500), result: 11.902, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-300), result: 12.902, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-240), result: 5.244, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-180), result: 8.212, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-120), result: 15.893, scramble:"222222",discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-60), result: 17.200, scramble:"222222", discipline: .three),
            factory.createSolve(date: now, result: 14.754, scramble:"222222", discipline: .three)
        ]
        
        coreDataManager.byDiscipline[.three] = solves
        
        try persistentContainer.viewContext.save()
        
        let result = try XCTUnwrap(coreDataManager.getAvgBest(from: .three, 5)) //
        
        XCTAssertEqual(result.0, 11.005, accuracy: 0.001, "Incorrect average calculation")
        
        XCTAssertEqual(result.1.count, 5, "Should return exactly 5 solves")
    }
    
    func testgetCurrentAO() throws{
        self.coreDataManager.deleteAllSolves()
        print("Solves count before saving in unit tests: \(self.coreDataManager.getSolveCount())")
        
        let expectation = self.expectation(description: "myExpectation")
        
        let now = Date()
        let _ = [
            factory.createSolve(date: now.addingTimeInterval(-500), result: 11.902, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-300), result: 12.902, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-240), result: 5.244, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-180), result: 8.212, scramble:"222222", discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-120), result: 15.893, scramble:"222222",discipline: .three),
            factory.createSolve(date: now.addingTimeInterval(-60), result: 17.200, scramble:"222222", discipline: .three),
            factory.createSolve(date: now, result: 14.754, scramble:"222222", discipline: .three)
        ]
        try persistentContainer.viewContext.save()
        
        self.coreDataManager.getCurrentAO(.three) { res5, res12 in
            
            print("Solves count after saving in unit tests: \(self.coreDataManager.getSolveCount())")
            
            XCTAssertEqual(res5, 12.953, accuracy: 0.001, "Incorrect average calculation in ao5")
            XCTAssertEqual(res12, 0.0, accuracy: 0.001, "Incorrect average calculation in ao12")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    private func resetAllManagedObjectContexts() {
        persistentContainer.viewContext.reset()
        XCTAssertFalse(persistentContainer.viewContext.hasChanges)
    }
}
