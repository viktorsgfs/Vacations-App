//
//  DesiredVacation+CoreDataProperties.swift
//  Desired Vacations App
//
//  Created by Synergy on 25.08.21.
//
//

import Foundation
import CoreData


extension DesiredVacation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DesiredVacation> {
        return NSFetchRequest<DesiredVacation>(entityName: "DesiredVacation")
    }

    @NSManaged public var name: String?
    @NSManaged public var hotel_name: String?
    @NSManaged public var location: String?
    @NSManaged public var necessary_money: Int64
    @NSManaged public var descript: String?
    @NSManaged public var imageName: String?
    @NSManaged public var imageBase64: Data?

}

extension DesiredVacation : Identifiable {

}
