//
//  ViewController.swift
//  NMLocalize
//
//  Created by Nicolas Mahé on 12/05/2016.
//  Copyright (c) 2016 Nicolas Mahé. All rights reserved.
//

import UIKit
import NMLocalize

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //this string are localize in the Localizable.strings file
    var message = L("first_string") + "\n"
    message += L("second_string") + "\n"
    
    //localize string with arguments
    message += L("third_string_with_paramter", "Nicolas", 25) + "\n"
    
    message += "Preferred language: " + Localize.preferredLanguage
    
    self.label.text = message
  }
}

