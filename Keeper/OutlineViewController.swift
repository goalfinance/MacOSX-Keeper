//
//  OutlineViewController.swift
//  Keeper
//
//  Created by Pan Qingrong on 28/11/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//

import Cocoa

let KEY_SEPARATOR = "separator"
let KEY_GROUP = "group"
let KEY_FOLDER = "folder"
let KEY_ENTRIES = "entries"
let KEY_LEAF = "leaf"
let KEY_RESOURCE = "resource"

class OutlineViewController:NSViewController{
    @IBOutlet var outlineView:NSOutlineView!
    @IBOutlet var treeController:NSTreeController!
    
    @objc var contents = [Node]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateOutlineViewContents()
        self.outlineView.enclosingScrollView?.verticalScroller?.floatValue = 0.0
        self.outlineView.enclosingScrollView?.contentView.scroll(to: NSMakePoint(CGFloat(0), CGFloat(0)))
        self.outlineView.selectionHighlightStyle = NSTableView.SelectionHighlightStyle.sourceList
    }
    
    func populateOutlineViewContents(){
        self.outlineView.isHidden = true
        if let dictPath = Bundle.main.path(forResource: "FeatureDict", ofType: "dict"){
            if let featureDict = NSDictionary.init(contentsOf: URL.init(fileURLWithPath: dictPath)){
                self.add(Entries: featureDict.value(forKey: KEY_ENTRIES) as! NSArray, DiscloseParent: true)
                self.selectParentFromSelection()
            }
        }
        self.outlineView.isHidden = false
    }
    
    func add(Entries entries:NSArray, DiscloseParent discloseParent:Bool){
        for entry in entries{
            if entry is NSDictionary{
                let e = entry as! NSDictionary
                if (e.value(forKey: KEY_SEPARATOR) != nil){
                    self.addSeparator()
                }else if (e.value(forKey: KEY_FOLDER) != nil){
                    let folderName = e.value(forKey: KEY_FOLDER)
                    self.addFolder(withName: folderName as? String)
                    if let children = e.value(forKey: KEY_ENTRIES){
                        self.add(Entries: children as! NSArray, DiscloseParent: false)
                    }
                    self.selectParentFromSelection()
                }else if (e.value(forKey: KEY_GROUP) != nil){
                    let groupName = e.value(forKey: KEY_GROUP)
                    self.addGroup(withName: groupName as? String)
                    if let children = e.value(forKey: KEY_ENTRIES){
                        self.add(Entries: children as! NSArray, DiscloseParent: false)
                    }
                    self.selectParentFromSelection()
                }else if (e.value(forKey: KEY_LEAF) != nil){
                    let leafName = e.value(forKey: KEY_LEAF)
                    let resource = e.value(forKey: KEY_RESOURCE)
                    self.addLeaf(withName: leafName as? String, resource: resource as? String)
                }
            }
        }
    }
    
    func selectParentFromSelection(){
        if self.treeController.selectedObjects.count > 0{
            let firstSelectedNode = self.treeController.selectedNodes[0]
            if let parentNode = firstSelectedNode.parent{
                self.treeController.setSelectionIndexPath(parentNode.indexPath)
            }else{
                //if the selectedNode has no parents
                let selectedIndexPaths = self.treeController.selectionIndexPaths
                self.treeController.removeSelectionIndexPaths(selectedIndexPaths)
            }
        }
    }
    
    func add(Node node:Node, SelectItsParent selectItsParent:Bool){
        if self.treeController.selectedObjects.count == 0{
            //No selection, so add the node on the root in turn.
            let indexPath = IndexPath.init(index: self.contents.count)
            self.treeController.insert(node, atArrangedObjectIndexPath: indexPath)
        }else{
            var selectedObject = self.treeController.selectedObjects[0]
            var selectedNode = selectedObject as! Node
            if selectedNode.isLeaf && selectedNode.isSeparator{
                //If the selected node is the Leaf or Separtor, find its parent for adding.
                self.selectParentFromSelection()
            }
            
            //There are some unnecesary codes. I've thought to use recursive call, but for worrying about the endless loop, I give it up.
            if self.treeController.selectedObjects.count == 0{
                //No selection, so add the node on the root in turn.
                let indexPath = IndexPath.init(index: self.contents.count)
                self.treeController.insert(node, atArrangedObjectIndexPath: indexPath)
            }else{
                selectedObject = self.treeController.selectedObjects[0]
                selectedNode = selectedObject as! Node
                let selectionIndexPath = self.treeController.selectionIndexPath!
                let indexPath = selectionIndexPath.appending(selectedNode.children.count)
                self.treeController.insert(node, atArrangedObjectIndexPath: indexPath)
            }
        }
        if selectItsParent{
            self.selectParentFromSelection()
        }
    }
    
    func addGroup(withName groupName:String?){
        let node = Node(withTitle: groupName ?? Node.untitledName, nodeType: NodeType.Group, resource: nil)
        self.add(Node: node, SelectItsParent:false)
    }
    
    func addFolder(withName folderName:String?){
        let node = Node(withTitle: folderName ?? Node.untitledName, nodeType: NodeType.Folder, resource: nil)
        self.add(Node: node, SelectItsParent:false)
    }
    
    func addLeaf(withName leafNodeName:String?, resource:String?){
        let node = Node(withTitle: leafNodeName ?? Node.untitledName, nodeType: NodeType.Leaf, resource: resource ?? Node.undefinedResource)
        self.add(Node:node, SelectItsParent:true)
    }
    
    func addSeparator(){
        let node = Node(withTitle: "", nodeType: NodeType.Separator, resource: nil)
        self.add(Node: node, SelectItsParent: true)
    }
    
    
}
