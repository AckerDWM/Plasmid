//
//  TranslateVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class TranslateVC: UIViewController
{
  
  @IBOutlet weak var textView: UITextView!
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
    self.textView.text = translateDNA(Global.selectedText)
  }
  
}
