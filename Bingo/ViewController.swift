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
    
    @IBOutlet weak var mTableView: UITableView!
    
    var avatars = Avatar()
    var keepArray = Dictionary<String,Bool>()
    var counter = 0
    var gameOver = false
    var currentSlot = 0
    var slotTimer:NSTimer!
    let scaleSize:CGFloat = 1.81
    var isSpinning = false
    var btn:UIButton!
    var resetButton:UIButton!
    private var mLeverAudioPlayer:AVAudioPlayer!
    private var mSlotRunAudioPlayer:AVAudioPlayer!
    private var mEndAudioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keepArray = avatars.getDictIndex()
        mEndAudioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bingo", ofType: "mp3")!))
        mLeverAudioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lever", ofType: "mp3")!))
        mSlotRunAudioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("slot_machine_sounds", ofType: "mp3")!))
        mSlotRunAudioPlayer.numberOfLoops = -1
        
        var y:CGFloat = 0.0
        //Add btn select next row
//        btn = UIButton(frame:CGRectMake(0, y, 200, 80))
//        btn.addTarget(self, action: Selector("runSlot"), forControlEvents: UIControlEvents.TouchUpInside)
//        btn.setTitle("NEXT SLOT", forState: UIControlState.Normal)
//        btn.backgroundColor = UIColor.greenColor()
//        btn.setBackgroundImage(UIImage(named: "btn_pressed.png"), forState: UIControlState.Highlighted)
//        btn.hidden = true
//        y += 90
      
        
        //Add btn reset
        resetButton = UIButton(frame:CGRectMake(0, y, 200, 80))
        resetButton.addTarget(self, action: Selector("resetSlot"), forControlEvents: UIControlEvents.TouchUpInside)
        resetButton.setTitle("RESET NOW", forState: UIControlState.Normal)
        resetButton.backgroundColor = UIColor.greenColor()
        resetButton.setBackgroundImage(UIImage(named: "btn_pressed.png"), forState: UIControlState.Highlighted)
        resetButton.hidden = true
        
//        self.view.addSubview(btn)
        self.view.addSubview(resetButton)
        
        
        mTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    
    
    @IBAction func toggleDebugBtn(sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Began){
//            btn.hidden = !btn.hidden
            resetButton.hidden = !resetButton.hidden
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetSlot(){
        self.avatars = Avatar()
        gameOver = false
        counter = 0
    
        for (k, _) in keepArray{
            keepArray.updateValue(false, forKey: k)
        }
        mTableView.reloadData()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        mTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        currentSlot = 0
    }
    
    func runSlot(){
        if currentSlot < self.avatars.getCountAvatar() - 3{
            ++currentSlot
        }else{
            // TODO: Reset tableview
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            mTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
            currentSlot = 0
        }
        let i = NSIndexPath(forRow: currentSlot, inSection: 0)
        mTableView.selectRowAtIndexPath(i, animated: true, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    func nextSlot()->Int{
        if currentSlot < self.avatars.getCountAvatar(){
            ++currentSlot
        }else{
            currentSlot = 0
        }
        return currentSlot
    }
    
    func setRow(c:Int){
        let lastAvatar = self.avatars.getElementAtIndex(index: c)
        if (keepArray.boolForKey(lastAvatar["index"]!) == true && gameOver == false){
            setRow(nextSlot())
        }else{
            keepArray.updateValue(true, forKey: lastAvatar["index"]!)
            let indexPath = NSIndexPath(forRow: c, inSection: 0)
            mTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            ++counter
            if(counter == PropertyListHelper.sharedInstance.getTotalItem()){
                gameOver = true
            }
        }
    }
    
    
    func getSelectedAvatar()->Dictionary<String, String>{
        let row = self.mTableView.indexPathsForVisibleRows![0].row
        return self.avatars.getElementAtIndex(index: row)
    }
    
    @IBAction func pullLever(sender: UIButton){
        if(self.avatars.getCountAvatar()>0 && !isSpinning && !gameOver){
            isSpinning = true
            GvAsyncTask<Void,[Dictionary<String, String>]>(
                doInBackground: { (params) -> [Dictionary<String, String>] in
                    var sleepInterval = 0.0001
                    var time = PropertyListHelper.sharedInstance.getSpeed(3.0)
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
                        self.setRow(self.currentSlot)
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
            }).execute()
            
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.avatars.getCountAvatar()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlotCell", forIndexPath: indexPath) as! SlotCellTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let avatar = self.avatars.getElementAtIndex(index: indexPath.row)
        cell.slot01.image = UIImage(named: avatar["icon"]!)
        cell.slot03.image = UIImage(named: avatar["icon"]!)
        cell.slot02.image = UIImage(named: avatar["number"]!)
        return cell
    }
}

