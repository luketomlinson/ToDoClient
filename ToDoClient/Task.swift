//
//  Task.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation

struct Task {
    var uid:String
    var description:String
    var title:String
    
    func toDict() -> [String:String] {
        var dict:[String:String] = [:]
        dict["uid"] = uid
        dict["description"] = description
        dict["title"] = title
        
        return dict
    }
    
    init(uid:String, description:String, title:String) {
        self.uid = uid
        self.description = description
        self.title = title
    }
    
    func toJSON() -> Data? {
        
        let dict = toDict()
        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
    
    init?(_ json:[String:AnyObject]) {
        
        guard let title = json["title"] as? String,
            let uid = json["uid"] as? String,
            let description = json["description"] as? String, title.characters.count > 0 else {
            return nil
        }
        
        self.title = title
        self.uid = uid
        self.description = description
    }
}
