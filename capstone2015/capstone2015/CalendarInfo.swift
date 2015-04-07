//
//  CalendarInfo.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 4/6/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation

class CalendarInfo{
    
    var text = " "
    var color: UIColor?
    
    init(color: UIColor){
        self.color = color
    }
    
    init (text: String, color: UIColor){
        self.text = text
        self.color = color
    }
    
}
