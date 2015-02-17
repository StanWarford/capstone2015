//
//  ClassModel.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/16/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation

class ClassModel {
    
    var name: String!
    var course: String!
    var status: String!
    var professor: String!
    var room: String!
    
    init(name: String, course: String, status: String, professor: String, room: String){
        self.name = name
        self.status = status
        self.course = course
        self.professor = professor
        self.room = room
    }
}