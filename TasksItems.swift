//
//  TasksItems.swift
//  Target
//
//  Created by Philippe Yong on 24/03/2020.
//  Copyright © 2020 Philippe Yong. All rights reserved.
//

import Foundation
import CoreData

public class Yellow: NSManagedObject {
    @NSManaged public var taskTitle: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarm: Date?
    @NSManaged public var taskColor: String?
}

public class Orange: NSManagedObject {
    @NSManaged public var taskTitle: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarm: Date?
    @NSManaged public var taskColor: String?
}

public class Green: NSManagedObject {
    @NSManaged public var taskTitle: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarm: Date?
    @NSManaged public var taskColor: String?
}

public class Blue: NSManagedObject {
    @NSManaged public var taskTitle: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarm: Date?
    @NSManaged public var taskColor: String?
}

// MARK: - Task Data

public class YellowData: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var second: NSNumber?}

public class OrangeData: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var second: NSNumber?
}

public class GreenData: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var second: NSNumber?
}

public class BlueData: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var second: NSNumber?
}

// MARK: - History Data

public class HistoryTimeData: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var createdAtStr: String?
    @NSManaged public var createdAtDate: Date?
    @NSManaged public var color: String?
    @NSManaged public var second: NSNumber?
}
