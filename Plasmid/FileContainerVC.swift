//
//  FileContainerVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/7/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class FileContainerVC: UIViewController
{

  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.navigationController?.navigationBarHidden = false
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTextView", name: "newSeqObject", object: nil)
  }
  
  func updateTextView()
  {
    self.textView.text = Global.activeSeqObject.stringRepresentation
  }

  @IBAction func linkDropboxBtn(sender: AnyObject)
  {
    DropboxManager.linkAccount(self)
  }
}
