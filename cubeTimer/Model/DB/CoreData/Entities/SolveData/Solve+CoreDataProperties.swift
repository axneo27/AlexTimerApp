//
//  Solve+CoreDataProperties.swift
//  cubeTimer
//
//  Created by Oleksii on 07.01.2025.
//
//

import Foundation
import CoreData

extension Solve {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Solve> {
        return NSFetchRequest<Solve>(entityName: "Solve")
    }

    @NSManaged public var date: Date?
    @NSManaged public var discipline: String?
    @NSManaged public var id: UUID?
    @NSManaged public var result: Float
    @NSManaged public var scramble: String?
    @NSManaged public var record: Record?

}

extension Solve : Identifiable {

}
