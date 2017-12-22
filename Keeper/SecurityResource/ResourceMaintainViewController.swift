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

let RESOURCE_EDIT_WINDOW_CONTROLLER = NSStoryboard.SceneIdentifier.init("ResourceEditWindowController")

class ResourceGroupValueObject{
    var name:String!
    var available:Bool = true
}

class ResourceValueObject{
    var name:String!
    var uri:String!
    var available:Bool = true
}

class ResourceMaintainViewController:NSViewController{
    @IBOutlet var outlineView:NSOutlineView!
    @IBOutlet var treeController:NSTreeController!
    @IBOutlet var arrayController:NSArrayController!
    @IBOutlet var tableView:NSTableView!
    
    @IBOutlet var addButtonResourceGroup:NSButton!
    @IBOutlet var removeButtonResourceGroup:NSButton!
    @IBOutlet var addButtonResource:NSButton!
    @IBOutlet var removeButtonResource:NSButton!
    
    var manangedObjectContext:NSManagedObjectContext!
    var resourceGroupEditWindowController:NSWindowController!
    var resourceEditWindowController:NSWindowController!
    
    @objc var content:[ResourceGroup] = [ResourceGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resourceGroupEditWindowController = NSStoryboard.main!.instantiateController(withIdentifier: RESOURCE_GROUP_EDIT_WINDOW_CONTROLLER) as! NSWindowController
        
        self.resourceEditWindowController = self.storyboard?.instantiateController(withIdentifier: RESOURCE_EDIT_WINDOW_CONTROLLER) as! NSWindowController
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.manangedObjectContext = self.view.window!.windowController!.document!.managedObjectContext
     
        let fetchRequest = NSFetchRequest<ResourceGroup>(entityName: "ResourceGroup")
        fetchRequest.predicate = NSPredicate(format: "parent = nil")
        do {
            self.treeController.content = try self.manangedObjectContext.fetch(fetchRequest)
            self.resourceGroupInitialState()
        }catch{
            
        }
    }
    
    func performAddingResourceGroup(valueObject:ResourceGroupValueObject){
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
    
    func performAddingResource(valueObject:ResourceValueObject){
        let newResource = NSEntityDescription.insertNewObject(forEntityName: "Resource", into: self.manangedObjectContext)
        newResource.setValue(valueObject.name, forKey: "name")
        newResource.setValue(valueObject.uri, forKey: "uri")
        let resourceGroup = self.treeController.selectedObjects[0] as! ResourceGroup
        newResource.setValue(resourceGroup, forKey: "Group")
        self.arrayController.addObject(newResource)
        
    }
    
    @IBAction func addResourceGroup(sender:NSButton){
        let editViewController = resourceGroupEditWindowController.contentViewController as! ResourceGroupEditViewController
        view.window!.beginSheet(resourceGroupEditWindowController.window!) { (modalResponse) in
            if modalResponse == NSApplication.ModalResponse.OK{
                let valueObject = ResourceGroupValueObject()
                valueObject.name = editViewController.savedValues[RESOURCE_GROUP_SAVED_VALUES_NAME] as! String
                if let isAvailable = editViewController.savedValues[RESOURCE_GROUP_SAVED_VALUES_IS_VAILABLE] as? Bool{
                    valueObject.available = isAvailable
                }

                self.performAddingResourceGroup(valueObject: valueObject)
            }
        }
    }
    
    @IBAction func addResource(sender:NSButton){
        let editWindowController = self.resourceEditWindowController.contentViewController as! ResourceEditViewController
        
        self.view.window!.beginSheet(resourceEditWindowController.window!) { (modalResponse) in
            if modalResponse == NSApplication.ModalResponse.OK{
                let resourceVO = ResourceValueObject()
                resourceVO.name = editWindowController.savedValues[RESOURCE_SAVED_VALUES_NAME] as! String
                resourceVO.uri = editWindowController.savedValues[RESOURCE_SAVED_VALUES_URI] as! String
                let isAvailable = editWindowController.savedValues[RESOURCE_SAVED_VALUES_AVAILABLE] as! Bool
                resourceVO.available = isAvailable
                
                self.performAddingResource(valueObject: resourceVO)
                self.resourceEditableState()
            }
            
        }
    }
    
    func resourceGroupInitialState(){
        self.addButtonResourceGroup.isEnabled = true
        self.removeButtonResourceGroup.isEnabled = false
    }
    
    func resourceGroupEditableState(){
        self.addButtonResource.isEnabled = true
        self.removeButtonResourceGroup.isEnabled = true
    }
    
    func resourceInitialState(){
        self.addButtonResource.isEnabled = true
        self.removeButtonResource.isEnabled = false
    }
    
    func resourceEditableState(){
        self.addButtonResource.isEnabled = true
        self.removeButtonResource.isEnabled = true
    }
    
}
