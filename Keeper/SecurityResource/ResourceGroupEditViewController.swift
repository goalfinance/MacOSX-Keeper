//
//  ResourceGroupEditViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 12/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

class ResourceGroupEditViewController:NSViewController{
    @IBOutlet var nameField:NSTextField!
    @IBOutlet var yesRadioButton:NSButton!
    @IBOutlet var noRadioButton:NSButton!
    
    var isVailable:Bool{
        set{
            if newValue {
                yesRadioButton.state = NSControl.StateValue.on
                noRadioButton.state = NSControl.StateValue.off
            }else{
                yesRadioButton.state = NSControl.StateValue.off
                noRadioButton.state = NSControl.StateValue.on
            }
        }
        
        get{
            if yesRadioButton.state == NSControl.StateValue.on && noRadioButton.state == NSControl.StateValue.off{
                return true
            }else{
                return false
            }
        }
    }
    
    var savedValues:NSDictionary = NSDictionary()
}
