//
//  CoreDataManager.swift
//  cubeTimer
//
//  Created by Oleksii on 08.01.2025.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Solve")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    @Published var solvesCount: Int = 0
    @Published var recordsCount: Int = 0
    
    public var byDiscipline: [Discipline: [Solve]] = [
        .two : [],
        .three : [],
        .four : [],
        .five: [],
        .six: []
    ] // use only in records
    
    public var byDisciplineIsEmpty: Bool {
        get {
            for dis in Discipline.allCases.dropLast() {
                if byDiscipline[dis]!.count != 0 {return false}
            }
            return true
        }
    }
    
    init() {
        DispatchQueue.main.async {
            self.solvesCount = self.getSolveCount()
            self.recordsCount = self.getRecordsCount()
        }
    }
    
    init(container: NSPersistentContainer) { // for unit tests
        self.persistentContainer = container
    }
    
    func saveContext(_ context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        context.performAndWait {
            do {
                try context.save()
                completion(true)
            } catch {
                print("Error in saveContext: \(error)")
                completion(false)
            }
        }
    }
    
    public func saveSolve(date: Date, result: Float, scramble: String, discipline: Discipline, completion: @escaping (Bool)->Void){
        persistentContainer.performBackgroundTask{ backgroundContext in
            let newSolve = Solve(context: backgroundContext)
            newSolve.discipline = Puzzlenames[discipline]
            newSolve.result = result
            newSolve.date = date
            newSolve.scramble = scramble
            newSolve.id = UUID()
            
//            self.solvesCount += 1 in ScrambleView
            do {
                try backgroundContext.save()
                completion(true)
            } catch {
                print("Error in saveSolve")
                completion(false)
            }
        }
    }
    // 1.solvesCount 2.some other variant of fetch 3. get this solve as a parameter<
    public func updRecords(completion: @escaping (Bool)->Void) { // some shit happened here and i remember it
        if let newSolve: Solve = getSolve(at: solvesCount - 1) {
            guard let dis = Puzzlenames.getByString(newSolve.discipline!) else {
                completion(false)
                return
            }
            persistentContainer.performBackgroundTask { bgContext in
                //add checks if its count is not as the solvesCount.
                self.clearByDiscipline()
                do {
                    try self.fetchAllSolves { solves in
                        guard let solves = solves else {
                            completion(false)
                            return
                        }
                        self.setByDiscipline(in: solves.sorted{$0.date! < $1.date!}) // sort!!!
                        self.updateRecordsDB(newSolve, dis: dis, context: bgContext, completion: completion)
                    }
                }
                catch {
                    print("Error in updRecords")
                    completion(false)
                    return
                }
            }
        }
        else {
            print("Error: Cannot get last solve in updRecords")
            completion(false)
        }
    }
    
    public func fetchAllSolves(completion: @escaping ([Solve]?)-> Void) throws {
        context.perform { [weak self] in // fixed something
            
            guard let self = self else {
                completion(nil)
                return
            }
            
            do {
                let items = try self.context.fetch(Solve.fetchRequest()) as? [Solve]
//                print("Number of solves fetched: \(items!.count)")
                completion(items)
            } catch {
                print("Cannot load solves")
                completion(nil)
            }
        }
    }
    
    public func deleteSolve(at index: Int, items array: [Solve]?, completion: @escaping (Bool)-> Void) {
        guard let array = array, index < array.count else {
            completion(false)
            return
        }
        self.performDeletion(for: array[index], completion: completion)
    }
    
    public func setRecords(dis: Discipline, completion: @escaping (Bool)->Void) {
        guard getSolveCount() > 0 else {
            completion(false)
            return
        }
        persistentContainer.performBackgroundTask{ bgContext in
            self.clearByDiscipline()
            do {
                try self.fetchAllSolves { solves in
                    guard let solves = solves else {
                        completion(false)
                        return
                    }
                    self.setByDiscipline(in: solves.sorted{$0.date! < $1.date!}) // sort!!!
                    self.setRecordsAfterDeletion(dis, bgContext, completion: completion)
                }
            } catch {
                print("Error in setRecords")
                completion(false)
            }
        }
    }
    
    private func performDeletion(for solve: Solve, completion: @escaping (Bool) -> Void) {
        persistentContainer.performBackgroundTask { bgContext in
//            self.solvesCount -= 1 in statisticsview
            do {
                self.context.delete(solve)

                try self.context.save()
                completion(true)
            } catch {
                print("WTH in performDeletion")
                completion(false)
            }
        }
    }
    
    public func getSolveCount() -> Int {
        let fetchRequest: NSFetchRequest<Solve> = Solve.fetchRequest()
        do {
            return try context.count(for: fetchRequest)
        } catch {
            print("Failed to count objects: \(error.localizedDescription)")
            return 0
        }
    }
    
    public func getSolve(at index: Int) -> Solve? {
        let fetchRequest: NSFetchRequest<Solve> = Solve.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchOffset = index

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch Solve at index \(index): \(error.localizedDescription)")
            return nil
        }
    }
    
    public func deleteAllSolves() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Solve.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        self.solvesCount = 0
        do {
            try context.execute(deleteRequest)
            self.deleteAllRecordsDB()
            try context.save()
        } catch {
            print("Failed to delete all solves: \(error.localizedDescription)")
        }
    }
    
    public func deleteAllSolves(where discipline: Discipline) {
        guard let puzzleName = Puzzlenames[discipline] else {return}
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Solve.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "discipline == %@", puzzleName)
        do {
            let countOfSolves = try context.count(for: fetchRequest)
            self.solvesCount -= countOfSolves
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
            
            self.deleteAllRecordsDB(where: discipline)
            try context.save() // maybe redundant
        } catch {
            print("Failed to delete all solves (\(puzzleName)): \(error.localizedDescription)")
        }
    }
}

