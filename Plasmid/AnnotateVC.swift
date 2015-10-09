//
//  AnnotateVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class AnnotateVC: UIViewController
{

  @IBOutlet weak var huePicker: HuePicker!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textView: UITextView!
  
  let newFeature = Seq.Feature()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
  }

  @IBAction func keyBtn(sender: AnyObject)
  {
  
  }
  
  @IBAction func addBtn(sender: AnyObject)
  {
    let colorTouple: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) = (hue: huePicker.h, saturation: 1, brightness: 1)
    newFeature.color = colorTouple
    newFeature.label = textField.text
    // assign positions
  }

}
