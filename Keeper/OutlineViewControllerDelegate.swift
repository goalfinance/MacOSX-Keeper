//
//  OutlineViewControllerDelegate.swift
//  Keeper
//
//  Created by Pan Qingrong on 28/11/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

extension OutlineViewController:NSOutlineViewDelegate{
    
    private func convertToNode(item:Any) -> Node?{
        if item is NSTreeNode{
            let treeNode = item as! NSTreeNode
            let node = treeNode.representedObject as! Node
            
            return node
        }else{
            return nil
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let node = self.convertToNode(item: item){
            return !node.isGroup && !node.isSeparator
        }else{
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let node = self.convertToNode(item: item){
            return node.isGroup
        }else{
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let node = self.convertToNode(item: item){
            if node.isSeparator{
                return self.outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Separator"), owner: self)
            }else{
                let identifier = self.outlineView.tableColumns[0].identifier
                let tableCellView = self.outlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
                tableCellView?.textField?.stringValue = node.nodeTitle
                tableCellView?.imageView?.image = node.nodeIcon
                return tableCellView
            }
//            }else{
//                let identifier = self.outlineView.tableColumns[0].identifier
//                let tableCellView = self.outlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
//                tableCellView?.textField?.stringValue = node.nodeTitle
//                tableCellView?.imageView?.image = node.nodeIcon
//                return tableCellView
//            }
        }else{
            return nil
        }
    }
}
