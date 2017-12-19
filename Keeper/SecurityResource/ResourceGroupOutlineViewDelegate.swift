//
//  ResourceGroupOutlineViewDelegate.swift
//  Keeper
//
//  Created by Pan Qingrong on 19/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

extension ResourceMaintainViewController:NSOutlineViewDelegate{
    func item2ResourceGroup(item:Any) -> ResourceGroup?{
        if item is NSTreeNode{
            let treeNode = item as! NSTreeNode
            if treeNode.representedObject is ResourceGroup{
                let resourceGroupOfItem = treeNode.representedObject as! ResourceGroup
                return resourceGroupOfItem
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
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
                tableCellView?.imageView?.image = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIconResource)))
                
                return tableCellView
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
}