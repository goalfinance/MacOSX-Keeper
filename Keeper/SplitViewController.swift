//
//  SpliterViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 01/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

class SplitViewController:NSSplitViewController{
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.managedObjectContext = self.view.window?.windowController?.document?.managedObjectContext
    }
}
