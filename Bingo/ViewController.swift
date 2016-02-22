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
    @IBOutlet weak var mLevelView: GvLeverView!
    @IBOutlet weak var slotIcon01: UIImageView!
    @IBOutlet weak var slotIcon02: UIImageView!
     @IBOutlet weak var slotNumber: UIImageView!
    
    var avatars = Avatar()
    
    var currentSlot = 0
    var slotTimer:NSTimer!
    let scaleSize:CGFloat = 1.81
    var isSpinning = false
    var btn:UIButton!
    private var mLeverAudioPlayer:AVAudioPlayer!
    private var mSlotRunAudioPlayer:AVAudioPlayer!
    private var mEndAudioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        btn = UIButton(frame:CGRectMake(0, 0, 200, 80))
        btn.addTarget(self, action: Selector("runSlot"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTitle("NEXT SLOT", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.greenColor()
        btn.setBackgroundImage(UIImage(named: "btn_pressed.png"), forState: UIControlState.Highlighted)
        btn.hidden = true
        self.view.addSubview(btn)
        self.runSlot()
    }
    
    
    
    @IBAction func toggleDebugBtn(sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Began){
            btn.hidden = !btn.hidden
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
        
        var avatar = self.avatars.getElementAtIndex(index: currentSlot%self.avatars.getCountAvatar())
        self.slotIcon01.image = UIImage(named: avatar["icon"]!)
        self.slotIcon02.image = self.slotIcon01.image
        self.slotNumber.image = UIImage(named: avatar["number"]!)
    }
    
    
    func getSelectedAvatar()->Dictionary<String, String>{
        return self.avatars.getElementAtIndex(index: currentSlot%self.avatars.getCountAvatar())
    }
    
    func pullLever(){
        
        if(self.avatars.getCountAvatar()>0 && !isSpinning){
            isSpinning = true
            GvAsyncTask<Void,[Dictionary<String, String>]>(
                doInBackground: { (params) -> [Dictionary<String, String>] in
                    var sleepInterval = 0.0001
                    var time = PropertyListHelper.sharedInstance.getSpeed(5.0)
                    let cd = self.getSelectedAvatar()
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

