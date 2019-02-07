//
//  ResourceEditViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 22/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let RESOURCE_SAVED_VALUES_NAME = "name"
let RESOURCE_SAVED_VALUES_URI = "uri"
let RESOURCE_SAVED_VALUES_AVAILABLE = "available"

class ResourceEditViewController:NSViewController, NSControlTextEditingDelegate{
    var savedValues:[String:AnyObject] = [String:AnyObject]()
    
    @IBOutlet var yesRadioButton:NSButton!
    @IBOutlet var noRadioButton:NSButton!
    @IBOutlet var nameField:NSTextField!
    @IBOutlet var uriField:NSTextField!
    @IBOutlet var doneButton:NSButton!
    
    @IBAction func setAvailable(sender:NSButton!){
        if sender.tag == 1{
            self.isVailable = true
        }else{
            self.isVailable = false
        }
    }
    
    @IBAction func done(sender:NSButton!){
        savedValues[RESOURCE_SAVED_VALUES_NAME] = nameField.stringValue as AnyObject
        savedValues[RESOURCE_SAVED_VALUES_URI] = uriField.stringValue as AnyObject
        savedValues[RESOURCE_SAVED_VALUES_AVAILABLE] = self.isVailable as AnyObject
        
        self.clearValues()
        
        self.view.window!.sheetParent!.endSheet(self.view.window!, returnCode: NSApplication.ModalResponse.OK)
    }
    
    @IBAction func cancel(sender:NSButton!){
        self.clearValues()
        self.view.window!.sheetParent!.endSheet(self.view.window!, returnCode: NSApplication.ModalResponse.cancel)
    }
    
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
            if yesRadioButton.state == NSControl.StateValue.on && noRadioButton.state == NSControl.StateValue.off {
                return true
            }else{
                return false
            }
        }
    }
    
    func doneAllowed() -> Bool{
        return !nameField.stringValue.isEmpty && !uriField.stringValue.isEmpty
    }
    
    func clearValues(){
        nameField.stringValue = ""
        uriField.stringValue = ""
        self.isVailable = true
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let name = savedValues[RESOURCE_SAVED_VALUES_NAME]{
            nameField.stringValue = name as! String
        }
        if let uri = savedValues[RESOURCE_SAVED_VALUES_URI]{
            uriField.stringValue = uri as! String
        }
        if let available = savedValues[RESOURCE_SAVED_VALUES_AVAILABLE]{
            let resourceAvailable = available as! Bool
            self.isVailable = resourceAvailable
        }
        doneButton.isEnabled = self.doneAllowed()
    }
    
    func controlTextDidChange(_ obj: Notification) {
        doneButton.isEnabled = self.doneAllowed()
    }
}
