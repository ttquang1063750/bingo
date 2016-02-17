//
//  Avatar.swift
//  Bingo
//
//  Created by GUMI-QUANG on 2/16/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import Foundation
class Avatar: NSObject {
    var avatars:[Dictionary<String, String>] = []
    override init() {
        super.init()
        for i in 1...72{
            var dic = Dictionary<String, String>()
            dic.updateValue("icon_\(i).png", forKey: "icon")
            dic.updateValue("number_\(i).png", forKey: "number")
            avatars.append(dic)
        }
    }
    
    func getCountAvatar() -> Int{
        return self.avatars.count
    }
    
    func getElementAtIndex(index index:Int)->Dictionary<String, String>{
        return self.avatars[index]
    }
    
}
