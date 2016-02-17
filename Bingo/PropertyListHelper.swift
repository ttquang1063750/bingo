//
//  PropertyListHelper.swift
//  Tamon's Time
//
//  Created by Nguyen Le Hien on 12/2/14.
//  Copyright (c) 2014 Gumi Viet. All rights reserved.
//

import Foundation

class PropertyListHelper {
    class var sharedInstance: PropertyListHelper {
        struct Static {
            static var instance: PropertyListHelper?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = PropertyListHelper()
        }
        return Static.instance!
    }
    
    private let KEY_ENABLE_SOUND = "KEY_ENABLE_SOUND"
    private let KEY_SPEED = "KEY_SPEED"
    
    
    func isEnableSound(defaultValue:Bool = true) -> Bool{
        if(NSUserDefaults.standardUserDefaults().valueForKey(KEY_ENABLE_SOUND) == nil){
            return defaultValue
        }
        return NSUserDefaults.standardUserDefaults().boolForKey(KEY_ENABLE_SOUND)
    }
    
    func setEnableSound(isEnable:Bool){
        NSUserDefaults.standardUserDefaults().setBool(isEnable, forKey: KEY_ENABLE_SOUND)
    }
    
    func setSpeed(speedValue:Float){
        NSUserDefaults.standardUserDefaults().setFloat(speedValue, forKey: KEY_SPEED)
    }
    
    func getSpeed(defaultValue:Float = 2.0) -> Float{
        if(NSUserDefaults.standardUserDefaults().valueForKey(KEY_SPEED) == nil){
            return defaultValue
        }
        return NSUserDefaults.standardUserDefaults().floatForKey(KEY_SPEED)
    }
    
    func synchronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}