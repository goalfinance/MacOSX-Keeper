//
//  ResourceMaintainViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 12/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let RESOURCE_GROUP_EDIT_WINDOW_CONTROLLER =
    NSStoryboard.SceneIdentifier.init(rawValue: "ResourceGroupEditWindowController")

class ResourceGroupValueObject{
    var name:String!
    var available:Bool = true
}

class ResourceMaintainViewController:NSViewController{
    @IBOutlet var outlineView:NSOutlineView!
    @IBOutlet var treeController:NSTreeController!
    
    var manangedObjectContext:NSManagedObjectContext!
    var editWindowController:NSWindowController!
    
    @objc var content:[ResourceGroup] = [ResourceGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editWindowController = NSStoryboard.main!.instantiateController(withIdentifier: RESOURCE_GROUP_EDIT_WINDOW_CONTROLLER) as! NSWindowController
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.manangedObjectContext = self.view.window!.windowController!.document!.managedObjectContext
    }
    
    func addResourceGroup(valueObject:ResourceGroupValueObject){
        let newResourceGroup = NSEntityDescription.insertNewObject(forEntityName: "ResourceGroup", into: self.manangedObjectContext)
        newResourceGroup.setValue(valueObject.name, forKey: "name")
        newResourceGroup.setValue(valueObject.available, forKey: "available")
        
        if self.treeController.selectedObjects.count == 0{
            let indexPath = IndexPath.init(index: self.content.count)
            self.treeController.insert(newResourceGroup, atArrangedObjectIndexPath: indexPath)
        }else{
            let selectedObj = self.treeController.selectedObjects[0]
            let selectedResourceGroup = selectedObj as! ResourceGroup
            let selectedIndexPath = self.treeController.selectionIndexPaths[0]
            var childrenCount:Int
            if let _ = selectedResourceGroup.children{
                childrenCount = selectedResourceGroup.children!.count
            }else{
                childrenCount = 0
            }
            let indexPath = selectedIndexPath.appending(childrenCount)
            self.treeController.insert(newResourceGroup, atArrangedObjectIndexPath: indexPath)
        }
    }
    
    @IBAction func add(sender:NSButton){
        let editViewController = editWindowController.contentViewController as! ResourceGroupEditViewController
        view.window!.beginSheet(editWindowController.window!) { (modelResponse) in
            if modelResponse == NSApplication.ModalResponse.OK{
                let valueObject = ResourceGroupValueObject()
                valueObject.name = editViewController.savedValues[RESOURCE_GROUP_SAVED_VALUES_NAME] as! String
                if let isAvailable = editViewController.savedValues[RESOURCE_GROUP_SAVED_VALUES_IS_VAILABLE] as? Bool{
                    valueObject.available = isAvailable
                }
                
                self.addResourceGroup(valueObject: valueObject)
            }
        }
    }
    
    
}
