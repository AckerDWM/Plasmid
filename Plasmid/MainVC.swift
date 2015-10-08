//
//  MainVC.swift
//  
//
//  Created by Daniel Acker on 10/7/15.
//
//

import UIKit

class MainVC: UIViewController, UITextViewDelegate
{

  @IBOutlet weak var textView: UITextView!

  let toolsActionView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
  
  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.textView.delegate = self
    let annotateAction = UIAlertAction(title: "Annotate", style: UIAlertActionStyle.Default)
      {
        action in
        self.performSegueWithIdentifier("annotateSegue", sender: nil)
    }
    let translateAction = UIAlertAction(title: "Translate", style: UIAlertActionStyle.Default)
      {
        action in
        self.performSegueWithIdentifier("translateSegue", sender: nil)
    }
    let inspectAction = UIAlertAction(title: "Inspect", style: UIAlertActionStyle.Default)
      {
        action in
        self.performSegueWithIdentifier("inspectSegue", sender: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
      {
        action in
    }
    self.toolsActionView.addAction(annotateAction)
    self.toolsActionView.addAction(translateAction)
    self.toolsActionView.addAction(inspectAction)
    self.toolsActionView.addAction(cancelAction)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTextView", name: "newAttributedString", object: nil)
  }
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = true
  }
  
  func updateTextView()
  {
    self.textView.attributedText = Global.seqAttributedString
  }
  
  // MARK : Text view delegate
  func textViewDidChangeSelection(textView: UITextView)
  {
    Global.selectedText = (textView.text as NSString).substringWithRange(textView.selectedRange)
  }

  @IBAction func toolsBtn(sender: AnyObject)
  {
    self.presentViewController(self.toolsActionView, animated: true, completion: nil)
  }
}
