//
//  ResourceGroupOutlineViewDatasource.swift
//  Keeper
//
//  Created by Pan Qingrong on 27/12/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let kNodesPBoardType = "com.kinematicsystemssss.outline.item"
extension ResourceMaintainViewController:NSOutlineViewDataSource, NSPasteboardItemDataProvider{
    // MARK: NSPasteboardItemDataProvider
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
        let s = "Outline Pasteboard Item"
        item.setString(s, forType: type)
    }
    
    // MARK: Drag & Drop
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let pasteBoardItem:NSPasteboardItem = NSPasteboardItem()
        pasteBoardItem.setDataProvider(self, forTypes: [NSPasteboard.PasteboardType.init(kNodesPBoardType)])
        return pasteBoardItem
    }
    
//    func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
//        pasteboard.declareTypes([NSPasteboard.PasteboardType.init(kNodesPBoardType)], owner: self)
//        self.draggedNodes = items
//        return true
//    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        //let data = NSKeyedArchiver.archivedData(withRootObject: draggedItems)
        self.draggedNodes = draggedItems
        session.draggingPasteboard.setData(Data(), forType: NSPasteboard.PasteboardType.init(kNodesPBoardType))
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        if item == nil{
            return NSDragOperation.generic
        }else{
            return NSDragOperation.move
        }
        
        
//        let result:NSDragOperation = NSDragOperation.generic
//        if item != nil {
//            let proposedNode = ((item as! NSTreeNode).representedObject) as! ResourceGroup
//
//            if index == -1{
//                return NSDragOperation.move
//            }else{
//                let draggedNode:ResourceGroup? = ((draggedNodes?[0] as? NSTreeNode)?.representedObject) as? ResourceGroup
//                if let dn = draggedNode{
//                    if dn === proposedNode{
//                        return NSDragOperation()
//                    }else{
//                        return NSDragOperation.move
//                    }
//                }
//            }
//        }
//
//        return result
    }
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        var proposedParentIndexPath:IndexPath
//        if item != nil{
//            let targetItem = item as! NSTreeNode
//            proposedParentIndexPath = targetItem.indexPath
//        }else{
//            proposedParentIndexPath = IndexPath.init()
//        }
//        let indexPath = proposedParentIndexPath.appending(index)
        
        if let draggedTreeNodes = self.draggedNodes {
            let draggedTreeNode = draggedTreeNodes[0] as! NSTreeNode
            if let draggedResourceGroup = self.item2ResourceGroup(item: draggedTreeNode){
                if item != nil{
                    let targetTreeNode = item as! NSTreeNode
                    proposedParentIndexPath = targetTreeNode.indexPath.appending(index)
                    if let parentResourceGroup = self.item2ResourceGroup(item: targetTreeNode){
                        if let children = parentResourceGroup.children{
                            var i = -1
                            for child in children{
                                let childResourceGroup = child as! ResourceGroup
                                childResourceGroup.setValue(self.getSortIdx(count: i), forKey: "idx")
                                i += 1
                            }
                        }
                    }else{
                        return false
                    }
                }else{
                    proposedParentIndexPath = IndexPath.init(index: index)
                    
                    var i:Int = 0
                    var rootLevelResourceGroups:[ResourceGroup] = [ResourceGroup]()
                    while i < self.outlineView.numberOfRows{
                        if let resourceGroup = self.item2ResourceGroup(item: self.outlineView.item(atRow: i)!){
                            rootLevelResourceGroups.append(resourceGroup)
                        }
                        i += 1
                    }
                    self.regenerateSortIdx(&rootLevelResourceGroups)
                    
                }
                let newSortIdx = self.sortIdxAfterDragged(newIndex: index)
                draggedResourceGroup.setValue(newSortIdx, forKey: "idx")
                let pboard:NSPasteboard = info.draggingPasteboard
                if (pboard.availableType(from: [NSPasteboard.PasteboardType.init(kNodesPBoardType)]) != nil){
                    self.handleInternalDrops(pborad: pboard, indexPath: proposedParentIndexPath)
                    return true
                }
            }
        }
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        self.draggedNodes = nil
    }
    
    func handleInternalDrops(pborad:NSPasteboard, indexPath:IndexPath){
        if self.draggedNodes != nil{
            self.treeController.move((self.draggedNodes as! [NSTreeNode]), to: indexPath)
            self.treeController.rearrangeObjects()
            var indexPathArray:[IndexPath] = [IndexPath]()
            for node in self.draggedNodes!{
                indexPathArray.append((node as! NSTreeNode).indexPath)
            }
            self.treeController.setSelectionIndexPaths(indexPathArray)
        }
    }
    
    
}
