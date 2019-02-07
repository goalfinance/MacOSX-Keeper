//
//  ResourceGroupOutlineViewDelegate.swift
//  Keeper
//
//  Created by Pan Qingrong on 19/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

extension ResourceMaintainViewController:NSOutlineViewDelegate{

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
       return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let identifierOfTableCellView = tableColumn?.identifier{
            let tableCellView = self.outlineView.makeView(withIdentifier: identifierOfTableCellView, owner: self) as? NSTableCellView
            
            if let resourceGroup = self.item2ResourceGroup(item: item){
                tableCellView?.textField?.stringValue = resourceGroup.value(forKey: "name") as! String
//                tableCellView?.imageView?.image = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIconResource)))
                tableCellView?.imageView?.image = nil
                
                return tableCellView
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if treeController.selectedObjects.count > 0 {
            self.resourceGroupEditableState()
            
            let selectedObj = treeController.selectedObjects[0]
            let selectedResourceGroup = selectedObj as! ResourceGroup
            if let resources = selectedResourceGroup.resources{
                self.arrayController.content = resources
                if resources.count > 0 {
                    self.resourceEditableState()
                }else{
                    self.resourceInitialState()
                }
            }else{
                self.arrayController.content = NSArray();
                self.resourceInitialState()
            }
            
        }else{
        }
    }
    
}
