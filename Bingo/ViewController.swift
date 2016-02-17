//
//  ViewController.swift
//  Bingo
//
//  Created by GUMI-QUANG on 2/16/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mPickerView: UIPickerView!
    @IBOutlet weak var mLevelView: GvLeverView!
    
    
    var avatars = Avatar()
    var currentSlot = -1
    var slotTimer:NSTimer!
    let scaleSize:CGFloat = 1.81

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let t0 = CGAffineTransformMakeTranslation(0, mPickerView.bounds.size.height*scaleSize)
        let s0 = CGAffineTransformMakeScale(1.0, scaleSize)
        let t1 = CGAffineTransformMakeTranslation (0, -mPickerView.bounds.size.height*scaleSize - 229)
        mPickerView.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1))
        
//        self.spinSlot()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runSlot(){
        if currentSlot < self.avatars.getCountAvatar(){
            ++currentSlot
        }else{
            currentSlot = 0
        }
        
        mPickerView.selectRow(currentSlot, inComponent: 0, animated: true)
        mPickerView.selectRow(currentSlot, inComponent: 1, animated: true)
        mPickerView.selectRow(currentSlot, inComponent: 2, animated: true)
    }
    
    func spinSlot(){
       slotTimer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runSlot"), userInfo: nil, repeats: true)
    }
    

}

extension ViewController: UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.avatars.getCountAvatar()
    }
}

extension ViewController: UIPickerViewDelegate{
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 216
    }
    
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 218
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var imageView:UIImageView
        var avatar = self.avatars.getElementAtIndex(index: row%self.avatars.getCountAvatar())
        if view == nil{
            imageView = UIImageView(frame: CGRectMake(0, 0, 192, 240/scaleSize))
        }else{
            imageView = view as! UIImageView
        }
        
        if component == 1 {
            imageView.image = UIImage(named: avatar["number"]!)
        } else {
            imageView.image = UIImage(named: avatar["icon"]!)
        }
        
        return imageView
    }
}

