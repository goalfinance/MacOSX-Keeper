//
//  ResourceGroupOutlineViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 12/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let RESOURCE_GROUP_EDIT_WINDOW_CONTROLLER = NSStoryboard.SceneIdentifier.init("ResourceGroupEditWindowController")

class ResourceGroupValueObject{
    var name:String!
    var available:Bool = true
}

class ResourceGroupOutlineViewController:NSViewController{
    @IBOutlet var outlineView:NSOutlineView!
    @IBOutlet var treeController:NSTreeController!
    var managedObjectContext:NSManagedObjectContext!
    var editWindowController:NSWindowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editWindowController = storyboard?.instantiateController(withIdentifier: RESOURCE_GROUP_EDIT_WINDOW_CONTROLLER) as! NSWindowController
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.managedObjectContext = self.view.window!.windowController!.document!.managedObjectContext
    }
    
    func addResouceGroup(valueObject:ResourceGroupValueObject){
        let newResourceGroup = NSEntityDescription.insertNewObject(forEntityName: "ResourceGroup", into: self.managedObjectContext)
        newResourceGroup.setValue(valueObject.name, forKey: "name")
        newResourceGroup.setValue(valueObject.available, forKey: "available")
        
        
    }
    
    
    @IBAction func addResourceGroup(sender:NSButton){
        let editViewController = editWindowController.contentViewController as! ResourceGroupEditViewController
        view.window!.beginSheet(editWindowController.window!) { (modelResponse) in
            if modelResponse == NSApplication.ModalResponse.OK{
                let valueObject = ResourceGroupValueObject()
                valueObject.name = editViewController.savedValues[RESOURCE_GROUP_SAVED_VALUES_NAME] as! String
                if let isAvailable = editViewController.savedValues[RESOURCE_GROUP_SAVED_VALUES_IS_VAILABLE] as? Bool{
                    valueObject.available = isAvailable
                }
                
                self.addResouceGroup(valueObject: valueObject)
            }
        }
    }
    
    @IBAction func removeResourceGroup(sender:NSButton){
        
    }
    
    
}
