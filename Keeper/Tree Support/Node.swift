//
//  BaseNode.swift
//  Keeper
//
//  Created by Pan Qingrong on 27/11/2017.
//  Copyright © 2017 Pan Qingrong. All rights reserved.
//
import Cocoa

enum NodeType {
    case Group
    case Folder
    case Separator
    case Leaf
}

class Node:NSObject{
    static var untitledName:String{
        return "UntitledName"
    }
    
    static var undefinedResource:String{
        return "UndefinedResource"
    }
    
    var nodeTitle:String!
    var nodeIcon:NSImage?{
        switch self.nodeType{
        case .Group:
            return nil
        case .Folder:
            let image = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericFolderIconResource)))
            return image
        case .Leaf:
            let image = NSWorkspace.shared.icon(forFileType: NSFileTypeForHFSTypeCode(OSType(kGenericStationeryIcon)))
            return image
        case .Separator:
            return nil
        }
    }
    var nodeType:NodeType = NodeType.Leaf
    @objc var children:[Node] = [Node]()
    var resource:String?
    
    @objc var isLeaf:Bool{
        get{
            if self.nodeType == NodeType.Leaf{
                return true
            }else{
                return false
            }
        }
    }
    
    var isGroup:Bool{
        get{
            if self.nodeType == NodeType.Group{
                return true
            }else{
                return false
            }
        }
    }
    
    var isFolder:Bool{
        get{
            if self.nodeType == NodeType.Folder{
                return true
            }else{
                return false
            }
        }
    }
    
    var isSeparator:Bool{
        get{
            if self.nodeType == NodeType.Separator{
                return true
            }else{
                return false
            }
        }
    }
    
    init(withTitle nodeTitle:String, nodeType:NodeType, resource:String?){
        self.nodeTitle = nodeTitle
        self.resource = resource
        self.nodeType = nodeType
    }
    
    override func isEqual(to object: Any?) -> Bool {
        guard object is Node else {return false}
        if let toNode = object{
            
            if self.nodeTitle == (toNode as! Node).nodeTitle {
                return true
            }else{
                return false
            }
        }
        return false
        
    }
    
}
