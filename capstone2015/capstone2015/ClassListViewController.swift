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
    
    @IBAction func addNewClass(sender: UIButton) {
        tableData.append("Biostatistics 315")
        classList?.reloadData()
    }
    
    var tableData = [String]()
    var newClass : String = ""
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        cell.textLabel?.text = "\(tableData[indexPath.row)"
        cell.detailTextLabel?.text = "\(tableData[indexPath.row])"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = ["Humanities 111", "Computer Science 105"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
