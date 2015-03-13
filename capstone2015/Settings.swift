//
//  Settings.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/26/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation
import CoreData

class Settings: NSManagedObject {

    @NSManaged var phoneNumber: String
    @NSManaged var email: String
    @NSManaged var notificationsOn: NSNumber

}
