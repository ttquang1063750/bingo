//
//  ViewController.swift
//  Bingo
//
//  Created by GUMI-QUANG on 2/16/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var mPickerView: UIPickerView!
    @IBOutlet weak var mLevelView: GvLeverView!
    
    
    var avatars = Avatar()
    var currentSlot = -1
    var slotTimer:NSTimer!
    let scaleSize:CGFloat = 1.81
    var isSpinning = false
    var isDebug = true
    private var mLeverAudioPlayer:AVAudioPlayer!
    private var mSlotRunAudioPlayer:AVAudioPlayer!
    private var mEndAudioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let t0 = CGAffineTransformMakeTranslation(0, mPickerView.bounds.size.height*scaleSize)
        let s0 = CGAffineTransformMakeScale(1.0, scaleSize)
        let t1 = CGAffineTransformMakeTranslation (0, -mPickerView.bounds.size.height*scaleSize - 229)
        mPickerView.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1))
        
        mEndAudioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bingo", ofType: "mp3")!))
        mLeverAudioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lever", ofType: "mp3")!))
        mSlotRunAudioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("slot_machine_sounds", ofType: "mp3")!))
        mSlotRunAudioPlayer.numberOfLoops = -1
        var levers:[UIImage] = []
        for i in 1...9{
            let pathName = "lever\(i).png"
            levers.append(UIImage(named: pathName)!)
        }
        mLevelView.setImageData(levers)
        mLevelView.setLevelReleaseCallBack(pullLever)
        
        if(isDebug){
            let btn = UIButton(frame:CGRectMake(0, 0, 200, 80))
            btn.addTarget(self, action: Selector("runSlot"), forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitle("NEXT", forState: UIControlState.Normal)
            btn.backgroundColor = UIColor.greenColor()
            btn.setBackgroundImage(UIImage(named: "btn_pressed.png"), forState: UIControlState.Highlighted)
            self.view.addSubview(btn)
        }
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
        
        mPickerView.selectRow(currentSlot, inComponent: 0, animated: false)
        mPickerView.selectRow(currentSlot, inComponent: 1, animated: false)
        mPickerView.selectRow(currentSlot, inComponent: 2, animated: false)
    }
    
    func spinSlot(){
       slotTimer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runSlot"), userInfo: nil, repeats: true)
    }
    
    func getSelectedAvatar(component:Int)->Dictionary<String, String>{
        let row = self.mPickerView.selectedRowInComponent(component)
        return self.avatars.getElementAtIndex(index: row%self.avatars.getCountAvatar())
    }
    
    func pullLever(){
        
        if(self.avatars.getCountAvatar()>0 && !isSpinning){
            isSpinning = true
            GvAsyncTask<Void,[Dictionary<String, String>]>(
                doInBackground: { (params) -> [Dictionary<String, String>] in
                    var sleepInterval = 0.0001
                    var time = PropertyListHelper.sharedInstance.getSpeed(5.0)
                    let cd = self.getSelectedAvatar(0)
                    while(time >= 0){
                        dispatch_async(dispatch_get_main_queue()){
                            self.runSlot()
                        }
                        sleepInterval = sleepInterval + 0.25/100
                        time = time - 0.1
                        NSThread.sleepForTimeInterval(sleepInterval)
                    }
                    if(time < 0){
                        self.mSlotRunAudioPlayer.stop()
                        self.mEndAudioPlayer.playSound()
                    }

                    NSThread.sleepForTimeInterval(1)
                    var selectedAvatars:[Dictionary<String, String>] = []
                    selectedAvatars.append(cd)
                    return selectedAvatars
                }, onPreExecute: { () -> Void in
                    self.mLeverAudioPlayer.playSound()
                    self.mSlotRunAudioPlayer.playSound()
                    return
                },
                onPostExecute: { (result) -> Void in
                    self.isSpinning = false
//                    self.mSlotRunAudioPlayer.stop()
//                    self.mEndAudioPlayer.playSound()
            }).execute()
            
        }
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
        (pickerView.subviews[1] ).hidden = true
        (pickerView.subviews[2] ).hidden = true
        pickerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        return imageView
    }
}

