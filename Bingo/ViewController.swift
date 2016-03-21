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
  
  @IBOutlet weak var slotView: UIView!
  
  var scrollView:LTInfiniteScrollView!
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
    
    let y:CGFloat = 0.0
    //Add btn select next row
    //        btn = UIButton(frame:CGRectMake(0, y, 200, 80))
    //        btn.addTarget(self, action: Selector("runSlot"), forControlEvents: UIControlEvents.TouchUpInside)
    //        btn.setTitle("NEXT SLOT", forState: UIControlState.Normal)
    //        btn.backgroundColor = UIColor.greenColor()
    //        btn.setBackgroundImage(UIImage(named: "btn_pressed.png"), forState: UIControlState.Highlighted)
    //        btn.hidden = true
    //        y += 90
    //        self.view.addSubview(btn)
    
    
    //Add btn reset
    resetButton = UIButton(frame:CGRectMake(0, y, 200, 80))
    resetButton.addTarget(self, action: Selector("resetSlot"), forControlEvents: UIControlEvents.TouchUpInside)
    resetButton.setTitle("RESET NOW", forState: UIControlState.Normal)
    resetButton.backgroundColor = UIColor.greenColor()
    resetButton.setBackgroundImage(UIImage(named: "btn_pressed.png"), forState: UIControlState.Highlighted)
    resetButton.hidden = true
    self.view.addSubview(resetButton)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.scrollView = LTInfiniteScrollView(frame: CGRectMake(0, 0, self.slotView.bounds.size.width, self.slotView.bounds.size.height))
    self.scrollView.verticalScroll = true
    self.scrollView.dataSource = self
    self.scrollView.delegate = self
    self.scrollView.maxScrollDistance = 0
    self.scrollView.userInteractionEnabled = false
    self.scrollView.clipsToBounds = true
    self.slotView.addSubview(self.scrollView)
    self.scrollView.reloadDataWithInitialIndex(0)
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
    
    currentSlot = 0
    self.scrollView.reloadDataWithInitialIndex(currentSlot)
  }
  
  func runSlot(){
      if currentSlot < self.avatars.getCountAvatar() - 1{
        ++currentSlot
        self.scrollView.scrollToIndex(currentSlot, animated: true)
      }else{
        currentSlot = 0
        self.scrollView.scrollToIndex(currentSlot, animated: false)
      }
  }
  
  func nextSlot()->Int{
    if currentSlot < self.avatars.getCountAvatar() - 1{
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
      self.scrollView.scrollToIndex(currentSlot, animated: false)
      ++counter
      if(counter == PropertyListHelper.sharedInstance.getTotalItem()){
        gameOver = true
      }
    }
  }
  
  
  @IBAction func pullLever(sender: UIButton){
    if(self.avatars.getCountAvatar()>0 && !isSpinning && !gameOver){
      isSpinning = true
      self.mLeverAudioPlayer.playSound()
      self.mSlotRunAudioPlayer.playSound()
//      self.runSlot()
      let timer = NSTimer.scheduledTimerWithTimeInterval(0.12, target: self, selector: Selector("runSlot"), userInfo: nil, repeats: true)
      let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(6 * Double(NSEC_PER_SEC)))
      dispatch_after(delayTime, dispatch_get_main_queue()) {
        self.isSpinning = false
        timer.invalidate()
        self.mSlotRunAudioPlayer.stop()
        self.mEndAudioPlayer.playSound()
        self.setRow(self.currentSlot)
      }
    }
  }
  
  
}

extension ViewController: LTInfiniteScrollViewDataSource, LTInfiniteScrollViewDelegate{
  func viewAtIndex(index: Int, reusingView view: UIView!) -> UIView! {
    let avatar = self.avatars.getElementAtIndex(index: index)
    
    var v:SlotView!
    if((view) != nil){
      v = view as! SlotView
    }else{
      v = SlotView(frame: CGRectMake(0,0,self.slotView.bounds.size.width,self.slotView.bounds.size.height))
    }
    
    v.mySlot01 = UIImage(named: avatar["icon"]!)
    v.mySlot03 = UIImage(named: avatar["icon"]!)
    v.mySlot02 = UIImage(named: avatar["number"]!)
    
    return v
  }
  
  
  func numberOfViews() -> Int {
    return self.avatars.getCountAvatar()
  }
  
  func numberOfVisibleViews() -> Int {
    return 1
  }
  
//  func updateView(view: UIView!, withProgress progress: CGFloat, scrollDirection direction: ScrollDirection) {
//    if(self.isSpinning){
//      self.runSlot()
//    }
//  }
  
}

