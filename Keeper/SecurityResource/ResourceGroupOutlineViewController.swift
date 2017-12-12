//
//  ResourceGroupOutlineViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 12/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

class ResourceGroupOutlineViewController:NSViewController{
    @IBOutlet var outlineView:NSOutlineView!
    @IBOutlet var treeController:NSTreeController!
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.managedObjectContext = self.view.window!.windowController!.document!.managedObjectContext
    }
    
    @IBAction func addResourceGroup(sender:NSButton){
        
    }
    
    @IBAction func removeResourceGroup(sender:NSButton){
        
    }
    
    
}
