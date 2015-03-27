//
//  SearchViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/9/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResults: UITableView!
    
    var model = ["COSC 315","HUM 111","HUM 112","COSC 415","PHYS 210","JWP 100","GSHU 410"]
    var filteredModel = [JSON]()
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredModel = []
        
        for section in classList {
            if (section["professor"].string!.rangeOfString(searchText) != nil){
                filteredModel.append(section)
            }
        }
        
        searchResults.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchCell") as SearchTableViewCell
        // create cell
        
        let classFollowing = filteredModel[indexPath.row]
        cell.setCell(classFollowing["name"].string!, courseNumber: classFollowing["section"].string!, status: classFollowing["status"].string!, professor: classFollowing["professor"].string!, room: classFollowing["room"].string!)
        cell.status.textColor = emeraldGreen
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModel.count
    }

    @IBAction func hideKeyboard(sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
