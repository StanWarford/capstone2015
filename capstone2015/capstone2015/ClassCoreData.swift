//
//  ClassCoreData.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/16/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation
import CoreData

class ClassCoreData: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var professor: String
    @NSManaged var course: String
    @NSManaged var status: String
    @NSManaged var room: String

}
