//
//  ClassEntity.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/31/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation
import CoreData

//Core Data Model used to store the classes a User is following
class ClassEntity: NSManagedObject {

    //Keys used to identify a class in classDict (JSON Dictionary of classes)
    @NSManaged var deptKey: String
    @NSManaged var courseKey: String
    @NSManaged var sectionKey: String

}
