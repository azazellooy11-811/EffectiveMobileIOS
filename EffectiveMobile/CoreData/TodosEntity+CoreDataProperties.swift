//
//  TodosEntity+CoreDataProperties.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 22.11.2024.
//
//

import Foundation
import CoreData


extension TodosEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodosEntity> {
        return NSFetchRequest<TodosEntity>(entityName: "TodosEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var userId: Int64

}

extension TodosEntity : Identifiable {

}
