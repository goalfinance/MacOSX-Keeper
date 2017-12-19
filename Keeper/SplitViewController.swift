//
//  SpliterViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 01/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let VIEW_CONTROLLER_FOR_TEST = NSStoryboard.SceneIdentifier.init(rawValue: "ResourceMaintainViewController")

class SplitViewController:NSSplitViewController{
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.managedObjectContext = self.view.window?.windowController?.document?.managedObjectContext
        
    }
    
    func viewController4Test()->NSViewController{
        return NSStoryboard.main!.instantiateController(withIdentifier: VIEW_CONTROLLER_FOR_TEST) as! NSViewController
    }
    
    func embedChildViewController4Test(){
        let currentDetailViewController = self.detailViewController()
        let childViewController4Test = self.viewController4Test()
        currentDetailViewController.addChildViewController(childViewController4Test)
        currentDetailViewController.view.addSubview(childViewController4Test.view)
        let views:[String:Any] = ["targetView":childViewController4Test.view]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|targetView|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: views)

        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|targetView|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(verticalConstraints)
        
    }
    
    func detailViewController()->NSViewController{
        let rightSplitViewItem = self.splitViewItems[1]
        return rightSplitViewItem.viewController
    }
}
