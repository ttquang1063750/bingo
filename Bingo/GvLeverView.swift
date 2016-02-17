//
//  GvImageView.swift
//  Cleanup Time
//
//  Created by Nguyen Le Hien on 11/28/14.
//  Copyright (c) 2014 Gumi Viet. All rights reserved.
//

import UIKit

class GvLeverView: UIImageView {
    
    private var imageData:[UIImage]!
    
    func setImageData(imageData:[UIImage]){
        self.imageData = imageData
    }
    
    private var mPanGesture:UIPanGestureRecognizer!
    private var isSwipeDown:Bool = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mPanGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.addGestureRecognizer(mPanGesture)
        self.userInteractionEnabled = true
    }
    
    private var onReleaseLevel:(()->Void)!
    private var isMaxLevel:Bool = false
    private var mLastGestureVelocity:CGPoint!
    private var isValidVelocity:Bool = false
    func handlePanGesture(gesture:UIPanGestureRecognizer){
        let currentVelocity = gesture.locationInView(self)
        if(gesture.state == UIGestureRecognizerState.Began){
            if(currentVelocity.y <= 90){
                self.mLastGestureVelocity = currentVelocity
                isValidVelocity = true
            }else{
                isValidVelocity = false
            }
        }else if(gesture.state == UIGestureRecognizerState.Changed){
            if(isValidVelocity && currentVelocity.y <= self.frame.height){
                if(currentVelocity.y > mLastGestureVelocity.y){
                    
                    let index = (Int)((currentVelocity.y / self.frame.height)*100)/imageData.count - 1
                    
                    if((index >= 0) && (index < imageData.count)){
                        self.image = imageData[index]
                        if(index == imageData.count - 1){
                            isMaxLevel = true
                        }
                    }
                }
            }
        }else if(gesture.state == UIGestureRecognizerState.Ended){
            if(isMaxLevel){
                self.onReleaseLevel()
            }
            isMaxLevel = false
            isValidVelocity = false
            self.image = imageData[0]
        }
        
    }
    
    func setLevelReleaseCallBack(onReleaseLevel:(()->Void)!){
        self.onReleaseLevel = onReleaseLevel
    }
}

class GvImageData{
    private var mLevel:Int!
    private var mImage:UIImage!
    init(level:Int,image:UIImage){
        self.mLevel = level
        self.mImage = image
    }
    
    func getLevel()->Int{
        return self.mLevel
    }
    
    func getImage() -> UIImage{
        return self.mImage
    }
}
