//
//  KeySelectionVCTableViewController.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/11/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class KeySelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var tableView: UITableView!
  
  var keys: [(key: String, definition: String)] = []
  var selectedKey: String?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.searchBar.returnKeyType = .Done
    self.searchBar.enablesReturnKeyAutomatically = false
    self.keys = parseGenbankFeatureKeys()
  }
  
  // MARK : Table view delegate
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    let key = self.keys[indexPath.row].key
    self.selectedKey = key
    let definition = self.keys[indexPath.row].definition
    self.textView.text = definition
  }

  // MARK: - Table view data source

  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.keys.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

      // Configure the cell...
    cell.textLabel?.text = keys[indexPath.row].key

    return cell
  }
  
  func parseGenbankFeatureKeys() -> [(key: String, definition: String)]
  {
    let keysPath = NSBundle.mainBundle().pathForResource("genbankAppendixII_featureKeys", ofType: "txt")
    let keysString = NSString(contentsOfFile: keysPath!, encoding: NSUTF8StringEncoding, error: nil)
    let lines = keysString!.componentsSeparatedByCharactersInSet(.newlineCharacterSet()) as! [String]
    var keys: [(key: String, definition: String)] = []
    keyLoop: for (var i = 0; i < lines.count; i++)
    {
      let line = lines[i]
      if line.hasPrefix("Feature Key")
      {
        var newKey: (key: String, definition: String) = (key: String(), definition: String())
        newKey.key = (line as NSString).substringFromIndex(count("Feature Key")).stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        if lines[i + 1].hasPrefix("Definition")
        {
          newKey.definition = (lines[i + 1] as NSString).substringFromIndex(count("Definition")).stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          definitionLoop: for (var ii = 2; ii > -1 ; ii++)
          {
            if !(lines[i + ii] as NSString).hasPrefix("Feature Key") && !(lines[i + ii] as NSString).hasPrefix("End")
            {
              newKey.definition += " " + (lines[i + ii] as NSString).stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
            }
            else
            {
              break definitionLoop
            }
          }
        }
        let letted = newKey
        keys.append(letted)
      }
    }
    return keys
  }
  
  // MARK : search bar delegate
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
  {
    let text = searchBar.text.lowercaseString
    keyLoop: for (var i = 0; i < self.keys.count; i++)
    {
      if keys[i].key.lowercaseString.hasPrefix(text)
      {
        let indexPath = NSIndexPath(forRow: i, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        break keyLoop
      }
    }
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar)
  {
    searchBar.resignFirstResponder()
  }

  // MARK : buttons
  @IBAction func doneBtn(sender: AnyObject)
  {
    if let key = self.selectedKey
    {
      NSNotificationCenter.defaultCenter().postNotificationName("keySelected", object: nil, userInfo: ["key" : key])
    }
    self.dismissViewControllerAnimated(true) { () in }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
