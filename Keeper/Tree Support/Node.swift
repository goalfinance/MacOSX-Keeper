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
    var nodeTitle:String!
    var nodeIcon:NSImage!
    var nodeType:NodeType = NodeType.Leaf
    var children:[Node] = [Node]()
    var resource:String?
    
    var isLeaf:Bool{
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
    
    init(withTitle nodeTitle:String, nodeType:NodeType, resource:String){
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
