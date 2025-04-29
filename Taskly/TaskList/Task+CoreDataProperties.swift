//
//  Task+CoreDataProperties.swift
//  Taskly
//
//  Created by Maha Alqarni on 29/10/1446 AH.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

   
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var notificationID: String?
    @NSManaged public var reminderDate: Date?
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
