//
//  Avatar.swift
//  Bingo
//
//  Created by GUMI-QUANG on 2/16/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import Foundation
class Avatar: NSObject {
    private var avatars:[Dictionary<String, String>] = []
    private var totalItem = PropertyListHelper.sharedInstance.getTotalItem()
    override init() {
        super.init()
        for i in 1...totalItem*500{
            let c = i%totalItem + 1
            var dic = Dictionary<String, String>()
            dic.updateValue("icon_\(c).png", forKey: "icon")
            dic.updateValue("number_\(c).png", forKey: "number")
            dic.updateValue("index_\(c)", forKey: "index")
            avatars.append(dic)
        }
        
        avatars = avatars.shuffled()
    }
    
    func getCountAvatar() -> Int{
        return self.avatars.count
    }
    
    func getElementAtIndex(index index:Int)->Dictionary<String, String>{
        return self.avatars[index]
    }
    
    func getDictIndex()->Dictionary<String,Bool>{
       var a = Dictionary<String,Bool>()
        for d in avatars{
            a.updateValue(false, forKey: d["index"]!)
        }
        return a
    }
}
