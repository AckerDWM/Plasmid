//
//  MainVC.swift
//  
//
//  Created by Daniel Acker on 10/7/15.
//
//

import UIKit

class MainVC: UIViewController, UITextViewDelegate, UISearchBarDelegate
{

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var dismissBtnOut: UIButton!

  let toolsActionView = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.searchBar.useDNAKeyboard()
    self.dismissBtnOut.hidden = true
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
    let scanAction = UIAlertAction(title: "Scan", style: UIAlertActionStyle.Default)
      {
        action in
        self.performSegueWithIdentifier("scanSegue", sender: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
      {
        action in
    }
    self.toolsActionView.addAction(annotateAction)
    self.toolsActionView.addAction(translateAction)
    self.toolsActionView.addAction(inspectAction)
    self.toolsActionView.addAction(scanAction)
    self.toolsActionView.addAction(cancelAction)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTextView", name: "newAttributedString", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "search", name: "searchButtonClicked", object: nil)
  }
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = true
  }
  
  func updateTextView()
  {
    self.textView.attributedText = Global.seqAttributedString
  }
  
  
  // search bar delegate search clicked replacement for custom keyboard
  func search()
  {
    let mutable = NSMutableAttributedString(attributedString: Global.seqAttributedString)
    let searchRegex = NSRegularExpression(pattern: self.searchBar.text, options: .CaseInsensitive, error: nil)
    let sequenceString = Global.activeSeqObject.sequence
    let matches = searchRegex?.matchesInString(sequenceString, options: nil, range: NSMakeRange(0, count(sequenceString)))
    if matches?.count > 0
    {
      for match in matches!
      {
        let range = match.range
        mutable.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: range)
      }
      self.textView.attributedText = mutable
      self.textView.scrollRangeToVisible(matches![0].range)
      // Show a way to dismiss highlighting
      self.dismissBtnOut.hidden = false
      self.searchBar.resignFirstResponder()
    }
  }
  
  @IBAction func dismissBtn(sender: AnyObject)
  {
    self.textView.attributedText = Global.seqAttributedString
    self.dismissBtnOut.hidden = true
  }
  
  // MARK : Text view delegate
  func textViewDidChangeSelection(textView: UITextView)
  {
    Global.selectedRange = textView.selectedRange
    Global.selectedText = (textView.text as NSString).substringWithRange(textView.selectedRange)
  }

  @IBAction func toolsBtn(sender: AnyObject)
  {
    self.presentViewController(self.toolsActionView, animated: true, completion: nil)
  }
  
}
