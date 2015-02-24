//
//  ServerConnection.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/19/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import Foundation

class ServerConnection {

    let url = "http://dbserver-capstone2015.rhcloud.com/get/classes"
    var classes: JSON!
    
    init(){
        populateClasses()
    }
    
    private func populateClasses() {
        // asynchronous alamofire get request
        request(.GET, self.url, parameters: nil)
            .responseJSON { (req, res, json, error) in
                if (error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(self.url)")
                    self.classes = JSON(json!)
                    //NSNumber
                    if let room = self.classes["COSC105.01"]["info"]["room"].string {
                        //Do something you want
                        println(room)
                    } else {
                        //Print the error
                        println(self.classes["COSC105.01"]["info"]["room"].error)
                    }
                }
        }
    }
    
}