//
//  CalendarCollectionViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/22/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

//A View representation of class information for the CalendarViewController
class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellText: UILabel?
    
    func setCell(text: String?, color: UIColor?) {
        self.cellText!.text = text
        self.backgroundColor = color
    }
    
}
