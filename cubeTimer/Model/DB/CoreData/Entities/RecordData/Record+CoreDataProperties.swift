//
//  Record+CoreDataProperties.swift
//  cubeTimer
//
//  Created by Oleksii on 20.02.2025.
//
//

import Foundation
import CoreData

extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var result: Float
    @NSManaged public var discipline: String?
    @NSManaged public var type: String?
    @NSManaged public var date: Date?
    @NSManaged public var solves: NSOrderedSet?

}

// MARK: Generated accessors for solves
extension Record {

    @objc(insertObject:inSolvesAtIndex:)
    @NSManaged public func insertIntoSolves(_ value: Solve, at idx: Int)

    @objc(removeObjectFromSolvesAtIndex:)
    @NSManaged public func removeFromSolves(at idx: Int)

    @objc(insertSolves:atIndexes:)
    @NSManaged public func insertIntoSolves(_ values: [Solve], at indexes: NSIndexSet)

    @objc(removeSolvesAtIndexes:)
    @NSManaged public func removeFromSolves(at indexes: NSIndexSet)

    @objc(replaceObjectInSolvesAtIndex:withObject:)
    @NSManaged public func replaceSolves(at idx: Int, with value: Solve)

    @objc(replaceSolvesAtIndexes:withSolves:)
    @NSManaged public func replaceSolves(at indexes: NSIndexSet, with values: [Solve])

    @objc(addSolvesObject:)
    @NSManaged public func addToSolves(_ value: Solve)

    @objc(removeSolvesObject:)
    @NSManaged public func removeFromSolves(_ value: Solve)

    @objc(addSolves:)
    @NSManaged public func addToSolves(_ values: NSOrderedSet)

    @objc(removeSolves:)
    @NSManaged public func removeFromSolves(_ values: NSOrderedSet)

}

extension Record : Identifiable {

}
