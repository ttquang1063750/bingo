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
    var totalItem = 72 //count from 1 to 72
    override init() {
        super.init()
        for i in 1...500{
            let d = Int(arc4random_uniform(UInt32(i))) + i
            let c = d%totalItem + 1
            var dic = Dictionary<String, String>()
            dic.updateValue("icon_\(c).png", forKey: "icon")
            dic.updateValue("number_\(c).png", forKey: "number")
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
