//
//  Common.swift
//  jpKenzai
//
//  Created by Thinh Nguyen on 10/27/14.
//  Copyright (c) 2014 GumiViet. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension String {
    
    ///Convert String to double
    func integerValue() -> Int {
        return (self as NSString).integerValue
    }
    
    ///Convert String to Datetime
    func dateTimeValue() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone=NSTimeZone(name: "GMT")
        let date = dateFormatter.dateFromString((self as NSString) as String)
        return date!
    }
    
    ///Convert String to float
    func floatValue() -> Float {
        return (self as NSString).floatValue
    }
    
    ///Convert String to double
    func doubleValue() -> Double {
        return (self as NSString).doubleValue
    }
}

extension NSDate {
    
    ///Convert String to double with custom format
    func toString(dateFormat dateFormat:String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone=NSTimeZone(name: "GMT")
        return  dateFormatter.stringFromDate(self)
    }
    
    ///Convert String to double with the default format
    func toString() -> String {
        return  toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    func getDayOfWeek()->Int {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = self
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
}

final class GvAsyncTask<Params, Result>{
    
    private var onPreExecute:(()->Void)?
    
    private var onPostExecute:((result:Result) -> Void)?
    
    private var doInBackground:((params:[Params]) -> Result)!
    
    init(doInBackground:((params:[Params]) -> Result), onPreExecute:(()->Void)? = nil, onPostExecute:((result:Result) -> Void)? = nil){
        self.onPreExecute = onPreExecute
        self.onPostExecute = onPostExecute
        self.doInBackground = doInBackground
    }
    
    func execute(params:Params...){
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            if(self.onPreExecute != nil ){
                self.onPreExecute!()
            }
            
            let results:Result = self.doInBackground(params: params)
            
            dispatch_async(dispatch_get_main_queue()){
                
                if(self.onPostExecute != nil){
                    self.onPostExecute!(result:results)
                }
            }
        })
    }
}

extension Dictionary {
    
    ///Just update the value for the key only if the value is not null
    mutating func updateValueNotNull(value: Value?, forKey key: Key){
        if(value != nil){
            self.updateValue(value!, forKey: key)
        }
    }
    
    func integerForKey(forKey: Key) -> Int?{
        var value = self[forKey] as? Int
        if(value == nil){
            value = (self[forKey] as? String)?.integerValue()
        }
        return value
    }
    
    func boolForKey(forKey: Key) -> Bool{
        return self[forKey] as! Bool
    }
    
    func stringForKey(forKey: Key) -> String{
        return self[forKey] as! String
    }
    
    func dateForKey(forKey: Key) -> NSDate{
        var value = self[forKey] as? NSDate
        
        if(value == nil){
            let interval:Double? = (self[forKey] as? Double)
            if(interval != nil){
                value = NSDate(timeIntervalSince1970: interval!)
            }
            
            let stringValue:String? = (self[forKey] as? String)
            
            if(stringValue != nil){
                value = stringValue?.dateTimeValue()
            }
        }
        return value!
    }
}

extension UIAlertController {
    // LeHien: Create a waiting dialog with title, message and Activity indicator
    class func createWaitingDialog(title:String?,message:String)->UIAlertController{
        let waitingDialog=UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicatorView.frame = CGRectMake(120, 60, 30, 30)
        indicatorView.color = UIColor.grayColor()
        waitingDialog.view.addSubview(indicatorView)
        indicatorView.startAnimating()
        return waitingDialog
    }
    // END
    
}
extension Array
{
    func shuffled() -> [Element] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}
extension Array{
    func indexOf(t:Element,isMatch:((Element) -> Bool))->Int{
        for (idx, element) in self.enumerate() {
            if isMatch(element) {
                return idx
            }
        }
        return -1
    }
}

extension AVAudioPlayer{
    
    func playSound(){
        if(PropertyListHelper.sharedInstance.isEnableSound(true)){
            self.play()
        }
    }
}

