//
//  CalendarCollectionViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/22/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellText: UILabel!
    
    func setCell(row: Int, column: Int){
        var text : String?
        var color: UIColor?
        cellText.textColor = UIColor.whiteColor()
        cellText.textAlignment = NSTextAlignment.Left
        var tuple = (column, row)
        switch(tuple){
        case (0, let i):
            let days = ["Mon","Tue","Wed","Thu","Fri"]
            text = days[i]
            cellText.textColor = UIColor.blackColor()
            cellText.textAlignment = NSTextAlignment.Center
        case (3, 0), (3 ,2):
            color = alizarinRed
            text = "9AM"
        case (4, 0), (4, 2):
            color = alizarinRed
            text = "COSC"
        case (8, 1), (8, 3):
            color = emeraldGreen
            text = "12PM"
        case (9, 1), (9, 3):
            color = emeraldGreen
            text = "HUM"
        default:
            break
        }
        cellText.text = text
        self.backgroundColor = color
    }
}
