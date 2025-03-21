//
//  RecordsDataManager.swift
//  cubeTimer
//
//  Created by Oleksii on 20.02.2025.
//

import Foundation
import CoreData

//@NSManaged public var result: Float
//@NSManaged public var discipline: String?
//@NSManaged public var type: String?
//@NSManaged public var date: Date?
//@NSManaged public var solves: NSOrderedSet?

extension DataManager {
    func updateRecordsDB(_ newSolve: Solve, dis: Discipline, context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        updSingleDB(newSolve, dis, context) { success1 in
            guard success1 else {
                completion(false)
                return
            }
            self.updAO5DB(dis, context) { success2 in
                guard success2 else {
                    completion(false)
                    return
                }
                self.updAO12DB(dis, context){success3 in
                    guard success3 else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    func updSingleDB(_ newSolve: Solve, _ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        cntxt.perform {
            let lastRes = newSolve.result
            let newSolveInContext = cntxt.object(with: newSolve.objectID) as! Solve
            self.findRecordDB(dis: dis, type: "single", cntxt) { foundRecord in
                let newSolves: NSOrderedSet = NSOrderedSet(array: [newSolveInContext])
                guard let FR = foundRecord else {
                    self.createRecordDB(res: lastRes, dis: dis, type: "single", date: newSolveInContext.date!, solves: newSolves, cntxt) { success in
                        if success {
                            self.saveContext(cntxt, completion: completion)
                        } else {
                            completion(false)
                        }
                    }
                    return
                }
                if FR.result > lastRes {
                    self.changeRecordDB(dis: dis, type: "single", solves: newSolves, date: newSolveInContext.date!, result: lastRes, cntxt) { success in
                        if success {
                            self.saveContext(cntxt, completion: completion)
                        } else {
                            completion(false)
                        }
                    }
                } else {
                    self.saveContext(cntxt, completion: completion)
                }
            }
        }
    }

    
    func updAO5DB(_ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        cntxt.perform {
            if let (avg5, array5) = self.getAvgLast(from: dis, 5) {
                self.findRecordDB(dis: dis, type: "ao5", cntxt) { foundRecord in
                    let date = array5[4].date!
                    let solvesInContext: [Solve] = array5.map { cntxt.object(with: $0.objectID) as! Solve }
                    let solves: NSOrderedSet = NSOrderedSet(array: solvesInContext)
                    
                    guard let FR = foundRecord else {
                        self.createRecordDB(res: avg5, dis: dis, type: "ao5", date: date, solves: solves, cntxt) { success in
                            if success {
                                self.saveContext(cntxt, completion: completion)
                            } else {
                                completion(false)
                            }
                        }
                        return
                    }
                    if FR.result > avg5 {
                        self.changeRecordDB(dis: dis, type: "ao5", solves: solves, date: date, result: avg5, cntxt) { success in
                            if success {
                                self.saveContext(cntxt, completion: completion)
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        self.saveContext(cntxt, completion: completion)
                    }
                }
            }
            else {
                completion(true)
            }
        }
    }
    
    func updAO12DB(_ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        cntxt.perform { // check
            if let (avg12, array12) = self.getAvgLast(from: dis, 12) {
                self.findRecordDB(dis: dis, type: "ao12", cntxt) { foundRecord in
                    let date = array12[11].date!
                    let solvesInContext: [Solve] = array12.map { cntxt.object(with: $0.objectID) as! Solve }
                    let solves: NSOrderedSet = NSOrderedSet(array: solvesInContext)
                    
                    guard let FR = foundRecord else {
                        self.createRecordDB(res: avg12, dis: dis, type: "ao12", date: date, solves: solves, cntxt) { success in
                            if success {
                                self.saveContext(cntxt, completion: completion)
                            } else {
                                completion(false)
                            }
                        }
                        return
                    }
                    if FR.result > avg12 {
                        self.changeRecordDB(dis: dis, type: "ao12", solves: solves, date: date, result: avg12, cntxt) { success in
                            if success {
                                self.saveContext(cntxt, completion: completion)
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        self.saveContext(cntxt, completion: completion)
                    }
                }
            }
            else {
                completion(true)
            }
        }
    }
    
    public func setRecordsAfterDeletion(_ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool)->Void) {
        setSingleforDiscipline(dis, cntxt) { success1 in
            guard success1 else {
                completion(false)
                return
            }
            self.setAO5forDiscipline(dis, cntxt) {success2 in
                guard success2 else {
                    completion(false)
                    return
                }
                self.setAO12forDiscipline(dis, cntxt){success3 in
                    guard success3 else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    func setSingleforDiscipline(_ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool)->Void) {
        cntxt.perform {
            let solve = self.findBestSolveDiscipline(dis)
            guard let solve = solve else {
                self.findRecordDB(dis: dis, type: "single", cntxt){foundRecord in
                    guard let _ = foundRecord else {
                        completion(true)
                        return
                    }
                    self.deleteRecordDB(dis: dis, type: "single", cntxt) {success in
                        if success {
                            self.saveContext(cntxt, completion: completion)
                        } else {
                            completion(false)
                        }
                    }
                }
                return
            }
            let SolveInContext = cntxt.object(with: solve.objectID) as! Solve
            self.changeRecordDB(dis: dis, type: "single", solves: NSOrderedSet(array: [SolveInContext]), date: SolveInContext.date!, result: SolveInContext.result, cntxt) { success in
                    if success {
                        self.saveContext(cntxt, completion: completion)
                    } else {
                        completion(false)
                    }
                }
        }
    }
    
    func setAO5forDiscipline(_ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool)->Void) {
        cntxt.perform { //check
            if let (bestAO5, solves5) = self.getAvgBest(from: dis, 5) {
                let date = solves5[4].date!
                let solvesInContext: [Solve] = solves5.map { cntxt.object(with: $0.objectID) as! Solve }
                let solves: NSOrderedSet = NSOrderedSet(array: solvesInContext)
                self.changeRecordDB(dis: dis, type: "ao5", solves: solves, date: date, result: bestAO5, cntxt) { success in
                    if success {
                        self.saveContext(cntxt, completion: completion)
                    } else {
                        completion(false)
                    }
                }
            } else {
                self.findRecordDB(dis: dis, type: "ao5", cntxt){foundRecord in
                    guard let _ = foundRecord else {
                        completion(true)
                        return
                    }
                    self.deleteRecordDB(dis: dis, type: "ao5", cntxt) {success in // w
                        if success {
                            self.saveContext(cntxt, completion: completion)
                        } else {
                            completion(false) //1
                        }
                    }
                }
            }
        }
    }
    
    func setAO12forDiscipline(_ dis: Discipline, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool)->Void) {
        cntxt.perform { //check
            if let (bestAO12, solves12) = self.getAvgBest(from: dis, 12) {
                let date = solves12[11].date! 
                let solvesInContext: [Solve] = solves12.map { cntxt.object(with: $0.objectID) as! Solve }
                let solves: NSOrderedSet = NSOrderedSet(array: solvesInContext)
                self.changeRecordDB(dis: dis, type: "ao12", solves: solves, date: date, result: bestAO12, cntxt) { success in
                    if success {
                        self.saveContext(cntxt, completion: completion)
                    } else {
                        completion(false)
                    }
                }
            } else {
                self.findRecordDB(dis: dis, type: "ao12", cntxt){foundRecord in
                    guard let _ = foundRecord else {
                        completion(true)
                        return
                    }
                    self.deleteRecordDB(dis: dis, type: "ao12", cntxt) {success in // w
                        if success {
                            self.saveContext(cntxt, completion: completion)
                        } else {
                            completion(false) //
                        }
                    }
                }
            }
        }
    }
}

extension DataManager {
    
    public func getRecordsForDiscipline(dis: Discipline, completion: @escaping ([String : Record?]) -> Void) {
        var output: [String : Record?] = [:]
        
        let group = DispatchGroup()
        
        group.enter()
        findRecordDB(dis: dis, type: "single", self.context, completion: { foundRecord in
            output["single"] = foundRecord
            group.leave()
        })
        
        group.enter()
        findRecordDB(dis: dis, type: "ao5", self.context, completion: { foundRecord in
            output["ao5"] = foundRecord
            group.leave()
        })
        
        group.enter()
        findRecordDB(dis: dis, type: "ao12", self.context, completion: { foundRecord in
            output["ao12"] = foundRecord
            group.leave()
        })
        group.notify(queue: .main) {
            completion(output)
        }
    }
    
    public func getRecordsCount() -> Int {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        do {
            return try context.count(for: fetchRequest)
        } catch {
            print("Failed to count objects: \(error.localizedDescription)")
            return 0
        }
    }
    
    private func createRecordDB(res: Float, dis: Discipline, type: String, date: Date, solves: NSOrderedSet, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool)->Void) {
        cntxt.perform {
            let newRecord = Record(context: cntxt)

            guard let discipline: String = Puzzlenames[dis] else {
                print("Error: Invalid")
                return
            }
            guard solves.count != 0 else {
                print("Error: Invalid 2")
                return
            }
            newRecord.result = res
            newRecord.discipline = discipline
            newRecord.type = type
            newRecord.date = date
            newRecord.solves = solves
            
            do {
                try cntxt.save()
                completion(true)
            } catch {
                completion(false)
                fatalError("Failed to save new Record: \(error.localizedDescription)")
            }
        }
    }
    
    private func changeRecordDB(dis: Discipline, type: String, solves: NSOrderedSet, date: Date, result: Float,
                                _ cntxt: NSManagedObjectContext,
                                completion: @escaping (Bool) -> Void) {
        cntxt.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "discipline == %@ AND type == %@", Puzzlenames[dis]!, type)
            do {
                let records = try cntxt.fetch(fetchRequest)
                guard let record = records.first else {
                    print("No matching record found for discipline \(dis) and type \(type)")
                    completion(false)
                    return
                }
                
                record.date = date
                record.result = result
                record.solves = solves

                try cntxt.save()
                completion(true)
            } catch {
                completion(false)
                fatalError("Failed to update record in DB: \(error.localizedDescription)")
            }
        }
    }

    public func findRecordDB(dis: Discipline, type: String, _ context: NSManagedObjectContext, completion: @escaping (Record?) -> Void) {
        context.perform {
            guard let puzzleName = Puzzlenames[dis] else {
                print("Invalid discipline: \(dis)")
                completion(nil)
                return
            }

            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "discipline == %@ AND type == %@", puzzleName, type)
//            fetchRequest.shouldRefreshRefetchedObjects = true

            do {
                let results = try context.fetch(fetchRequest)
                completion(results.first)
            } catch {
                print("Failed to fetch Record with discipline \(dis) and type \(type): \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    private func deleteRecordDB(dis: Discipline, type: String, _ cntxt: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "discipline == %@ AND type == %@", Puzzlenames[dis]!, type)
        
        cntxt.perform {
            do {
                let records = try cntxt.fetch(fetchRequest)
                let recordToDelete = records.first
                cntxt.delete(recordToDelete!)
                try cntxt.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func deleteAllRecordsDB() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Record.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All records deleted successfully.")
        } catch {
            print("Failed to delete all records: \(error.localizedDescription)")
        }
    }
}//######

extension DataManager {
    
    func setByDiscipline(in all_solves: [Solve]) -> Void {
        for solve in all_solves {
            if let discipline = Puzzlenames.getByString(solve.discipline!) {
                self.byDiscipline[discipline]?.append(solve)
            }
        }
    }
    
    func clearByDiscipline() {
        for puzzleName in Discipline.allCases.dropLast() {
            self.byDiscipline[puzzleName]!.removeAll()
        }
    }
    
    private func findBestSolveDiscipline(_ dis: Discipline) -> Solve? {
        guard let arr = byDiscipline[dis] else {
            return nil
        }
        guard !arr.isEmpty else { return nil }

        return arr.min(by: { $0.result < $1.result })
    }

    private func getAvgLast(from discipline: Discipline, _ num: Int) -> (Float32, [Solve])? {
        if let d = byDiscipline[discipline]{
            guard d.count >= num else {
                return nil
            }
            let lastNumsolves = d[(d.count - num)..<d.count]
            let results = lastNumsolves.map{Float32($0.result)}
            let avgNum = results.reduce(0.0, +) / Float32(results.count)
            return (avgNum, Array(lastNumsolves))
        }
        return nil
    }
    
    private func getAvgBest(from discipline: Discipline, _ num: Int) -> (Float32, [Solve])? {
        guard let d = byDiscipline[discipline] else  { return nil}
        guard d.count >= num else {
            return nil
        }
        var fives: [[Solve]] = []
        var avgs: [Float] = []
        for i in 0..<(d.count - num + 1) {
            let list5 = d[i..<i+num] // hell yeeeeeeeahhhh
            fives.append(Array<Solve>(list5))
            let results5 = list5.map{Float32($0.result)}
            let avgNum = results5.reduce(0.0, +) / Float32(results5.count)
            avgs.append(avgNum)
        }
        
        let (minIndex, minResult) = avgs.enumerated().min(by: { $0.1 < $1.1 })!
        return (minResult, fives[minIndex])
    }
}
