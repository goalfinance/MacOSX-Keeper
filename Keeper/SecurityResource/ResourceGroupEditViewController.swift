//
//  ResourceGroupEditViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 12/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let RESOURCE_GROUP_SAVED_VALUES_NAME = "name"
let RESOURCE_GROUP_SAVED_VALUES_IS_VAILABLE = "vailable"

class ResourceGroupEditViewController:NSViewController{
    @IBOutlet var nameField:NSTextField!
    @IBOutlet var yesRadioButton:NSButton!
    @IBOutlet var noRadioButton:NSButton!
    @IBOutlet var doneButton:NSButton!
    
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
    
    var savedValues:[String:AnyObject] = [String:AnyObject]()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let name = savedValues[RESOURCE_GROUP_SAVED_VALUES_NAME]{
            let resourceGroupName = name as! String
            nameField.stringValue = resourceGroupName
        }
        
        if let available = savedValues[RESOURCE_GROUP_SAVED_VALUES_IS_VAILABLE]{
            let resourceGroupAvailable = available as! Bool
            self.isVailable = resourceGroupAvailable
        }
        
        doneButton.isEnabled = doneAllowed()
    }
    
    func doneAllowed() -> Bool{
        return !nameField.stringValue.isEmpty
    }
    
    func clearValues(){
        nameField.stringValue = ""
        self.isVailable = true
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        doneButton.isEnabled = doneAllowed()
    }
    
    @IBAction func setAvailable(sender:NSButton){
        if sender.tag == 1 {
            self.isVailable = true
        }else{
            self.isVailable = false
        }
    }
    
    @IBAction func done(sender:NSButton){
        savedValues[RESOURCE_GROUP_SAVED_VALUES_NAME] = nameField.stringValue as AnyObject
        savedValues[RESOURCE_GROUP_SAVED_VALUES_IS_VAILABLE] = isVailable as AnyObject
        
        clearValues()
        
        view.window!.sheetParent!.endSheet(view.window!, returnCode: NSApplication.ModalResponse.OK)
    }
    
    @IBAction func cancel(sender:NSButton){
        clearValues()
        view.window!.sheetParent!.endSheet(view.window!, returnCode: NSApplication.ModalResponse.cancel)
    }
}
