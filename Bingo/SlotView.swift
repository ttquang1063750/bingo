//
//  SlotView.swift
//  Bingo
//
//  Created by Thanh Quang Ngoc Tuong on 3/20/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

@IBDesignable class SlotView: UIView {

  @IBOutlet weak var slot01: UIImageView!
  @IBOutlet weak var slot02: UIImageView!
  @IBOutlet weak var slot03: UIImageView!
  
  
  var view:UIView!
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
        setUp()
  }
  
  @IBInspectable var mySlot01:UIImage?{
    get{
      return slot01.image
    }
    set(mySlot01){
        slot01.image = mySlot01
    }
  }
  
  @IBInspectable var mySlot02:UIImage?{
    get{
      return slot02.image
    }
    set(mySlot02){
      slot02.image = mySlot02
    }
  }
  
  
  @IBInspectable var mySlot03:UIImage?{
    get{
      return slot03.image
    }
    set(mySlot03){
      slot03.image = mySlot03
    }
  }
  
  
  func setUp(){
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
    addSubview(view)
  }
  
  func loadViewFromNib()->UIView{
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "SlotView", bundle: bundle)
    let v = nib.instantiateWithOwner(nil, options: nil)
    NSLog("\(v)")
    return v[0] as! UIView
  }

}
