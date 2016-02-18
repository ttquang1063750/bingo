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
    private var totalItem = 72 //count from 1 to 72
    override init() {
        super.init()
        for i in 1...500{
            let c = i%totalItem + 1
            var dic = Dictionary<String, String>()
            dic.updateValue("icon_\(c).png", forKey: "icon")
            dic.updateValue("number_\(c).png", forKey: "number")
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
}
