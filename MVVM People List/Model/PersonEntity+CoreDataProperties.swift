//
//  PersonEntity+CoreDataProperties.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 04/08/2021.
//
//

import Foundation
import CoreData


extension PersonEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var id: Int64
}

extension PersonEntity : Identifiable {

}
