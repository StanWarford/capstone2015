//
//  ClassEntity.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/31/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation
import CoreData

class ClassEntity: NSManagedObject {

    @NSManaged var deptKey: String
    @NSManaged var courseKey: String
    @NSManaged var sectionKey: String

}
