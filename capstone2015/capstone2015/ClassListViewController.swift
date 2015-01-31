//
//  ClassListViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 1/29/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class ClassListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var classList: UITableView!
    
    struct Class {
        var className : String
        var status: String
        // add additional properties
    }
    
    @IBAction func addNewClass(sender: UIButton) {
        tableData.append(Class(className: "Biostatistics 315", status: "Open") )
        classList?.reloadData()
    }
    
    var tableData = [Class]()
    var newClass : String = ""
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        cell.textLabel?.text = "\(tableData[indexPath.row].className)"
        cell.detailTextLabel?.text = "\(tableData[indexPath.row].status)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = [Class(className: "Humanities 111",status: "Closed"), Class(className: "Computer Science 105",status: "Open")]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
