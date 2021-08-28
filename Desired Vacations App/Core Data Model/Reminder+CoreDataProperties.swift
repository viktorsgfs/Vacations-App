//
//  Reminder+CoreDataProperties.swift
//  Desired Vacations App
//
//  Created by Synergy on 28.08.21.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?

}

extension Reminder : Identifiable {

}
