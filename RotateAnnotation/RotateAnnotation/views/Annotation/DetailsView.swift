//
//  DetailsView.swift
//  RotateAnnotation
//
//  Created by user on 6/30/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit



class DetailsView: UIView {
    
    // define const
    let ANGLE_TO_PI = M_PI/180
    let SPEEDTIME_TO_PI = M_PI/180
    
    let SpaceX:CGFloat = 5
    let SpaceY:CGFloat = 5
    
    let scaleNum:CGFloat = 0.01
    let animationTime:CGFloat = 0.4
    
    
    let fSmallCircleD:CGFloat = 42
    let fSmallCircleD_Shadow:CGFloat = 42
    let fBigCircleD:CGFloat = 140
    let fBigCircleD_Shadow:CGFloat = 140
    
    let fSmallRectD_UD:CGFloat = 63
    let fSmallRectD_Mid:CGFloat = CGFloat(63 / sinf(Float(M_PI_4)))
    
    let fBigRectD1:CGFloat = 260
    
    var pStartCenter:CGPoint {
        get {
            return CGPointMake(self.center.x, CGRectGetHeight(self.bounds) - fBigRectD1/2)
        }
    }
    
    var fSpaceCenterY:CGFloat {
        get {
            return CGRectGetHeight(self.bounds)-fBigRectD1/2 - self.center.y
        }
    }
    
    let standRect = CGRectMake(0, 0, 200, 200)
    var spaceH:CGFloat {
        get {
            return (CGRectGetHeight(self.bounds) -  CGRectGetHeight(standRect))/2 + fSpaceCenterY
        }
    }
    
    var spaceW:CGFloat {
        get {
            return (CGRectGetWidth(self.bounds) -  CGRectGetWidth(standRect))/2
        }
    }
    
    let spaceFar:CGFloat = 1//2.5
    
    var blockButton: (btn:ItemView) -> Void = {(ItemView) in }
    var selectItem:ItemView!
    var startAngle:CGFloat = 0
    var itemsNum:NSInteger = 0
    var itemsAry:NSMutableArray = []
    var flickerTimer:NSTimer!
    
    class func getInstanceWithNib() -> DetailsView {
        var aView:DetailsView!
        aView = DetailsView(frame: CGRectMake(0, 0, 260, 260))
        return aView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUI(vo:MapItemInfoVO) {
        var childAray = vo.aryChild
        itemsNum = childAray.count + 1
        itemsAry.removeAllObjects()
        
        /********** main button **************/
        var frame0 = CGRectMake(0, 0, fBigRectD1, fBigRectD1)
        var ps0 = CGPointMake(CGRectGetWidth(frame0) / 2, fBigRectD1 - (fBigRectD1 - fBigCircleD) / 2 - (fBigCircleD_Shadow - fBigCircleD))
        var pe0 = CGPointMake(CGRectGetWidth(frame0) / 2, CGRectGetHeight(frame0))
        var buttonItem0 = ItemView(frame: frame0, buttonFrame: CGRectMake(0, 0, fBigCircleD_Shadow, fBigCircleD_Shadow), lineStart: ps0, lineEnd: pe0) { (btn) -> Void in
            self.clickButton(btn as! ItemView)
        }
        Utils.dealViewRoundCorners(buttonItem0.button, radius: CGRectGetHeight(buttonItem0.button.bounds)/2, borderWidth: 2)
        buttonItem0.button.setBackgroundImage(UIImage(named: "largeBubble"), forState: UIControlState.Normal)
        buttonItem0.superview?.backgroundColor = UIColor.yellowColor()
        buttonItem0.superview?.superview?.backgroundColor = UIColor.grayColor()
        buttonItem0.labelTitle_Main.text = vo.strTitle
        buttonItem0.labelTitle_Main.textColor = Utils.getColorByTag(self.tag)
        buttonItem0.startCenter = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds))
        buttonItem0.endCenter = pStartCenter
        buttonItem0.farCenter = CGPointMake(buttonItem0.endCenter.x, buttonItem0.endCenter.y - spaceFar * 2)
        buttonItem0.center = buttonItem0.startCenter
        self.addSubview(buttonItem0)
        buttonItem0.tag = ButtonType.ButtonType_Main.rawValue
        itemsAry.addObject(buttonItem0)
        
        /**************************************** leftDown button ******************************************************/
        if itemsNum > 1 {
            var frameUD = CGRectMake(0, 0, fSmallRectD_UD, fSmallRectD_UD)
            var ps1 = CGPointMake(CGRectGetWidth(frameUD) / 2 + CGFloat(cosf(Float(M_PI_4))) * fSmallCircleD / 2, CGRectGetHeight(frameUD) / 2 - CGFloat(sinf(Float(M_PI_4))) * fSmallCircleD / 2)
            var pe1 = CGPointMake(CGRectGetWidth(frameUD), 0)
            var buttonItem1 = ItemView(frame: frameUD, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps1, lineEnd: pe1) { (btn) -> Void in
                self.clickButton(btn as! ItemView)
            }
            buttonItem1.button.setBackgroundImage(UIImage(named: "smallBubble1"), forState: UIControlState.Normal)
            buttonItem1.startCenter = pStartCenter
            buttonItem1.endCenter = CGPointMake(CGRectGetWidth(buttonItem1.button.bounds)/2 + spaceW, CGRectGetHeight(self.bounds)-CGRectGetHeight(buttonItem1.button.bounds)/2 - spaceH)
            buttonItem1.farCenter = CGPointMake(buttonItem1.endCenter.x - CGFloat(cosf(Float(M_PI_4))) * spaceFar, buttonItem1.endCenter.y + CGFloat(sinf(Float(M_PI_4))) * spaceFar);
            buttonItem1.center = buttonItem1.startCenter;
            self.insertSubview(buttonItem1, belowSubview: buttonItem0)
            buttonItem1.hidden = true
            buttonItem1.tag = ButtonType.ButtonType_LeftDown.rawValue
            self.itemsAry .addObject(buttonItem1)
            
            /**************************************** rightDown button ******************************************************/
            if (itemsNum > 2) {
                var ps2 = CGPointMake(CGRectGetWidth(frameUD) / 2 - CGFloat(cosf(Float(M_PI_4))) * fSmallCircleD / 2, CGRectGetHeight(frameUD) / 2 - CGFloat(sinf(Float(M_PI_4))) * fSmallCircleD / 2)
                var pe2 = CGPointMake(0, 0)
                var buttonItem2 = ItemView(frame: frameUD, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps2, lineEnd: pe2, block: { (btn) -> Void in
                    self.clickButton(btn as! ItemView)
                })
                buttonItem2.button.setBackgroundImage(UIImage(named: "smallBubble2"), forState: UIControlState.Normal)
                buttonItem2.startCenter = pStartCenter;
                buttonItem2.endCenter = CGPointMake(CGRectGetWidth(self.bounds) - spaceW - CGRectGetWidth(buttonItem2.button.bounds)/2, CGRectGetHeight(self.bounds) - CGRectGetHeight(buttonItem2.button.bounds) / 2 - spaceH)
                buttonItem2.farCenter = CGPointMake(buttonItem2.endCenter.x + CGFloat(cosf(Float(M_PI_4))) * spaceFar, buttonItem2.endCenter.y + CGFloat(sinf(Float(M_PI_4))) * spaceFar)
                buttonItem2.center = buttonItem2.startCenter
                self.insertSubview(buttonItem2, belowSubview: buttonItem0)
                buttonItem2.hidden = true
                buttonItem2.tag = ButtonType.ButtonType_RightDown.rawValue
                itemsAry.addObject(buttonItem2)
                
                /**************************************** leftMid button ******************************************************/
                if (itemsNum > 3) {
                    var frameMid = CGRectMake(0, 0, fSmallRectD_Mid, fSmallRectD_Mid)
                    var ps3 = CGPointMake((CGRectGetWidth(frameMid) + fSmallCircleD) / 2, CGRectGetHeight(frameMid) / 2)
                    var pe3 = CGPointMake(CGRectGetWidth(frameMid), CGRectGetHeight(frameMid) / 2)
                    var buttonItem3 = ItemView(frame: frameMid, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps3, lineEnd: pe3, block: { (btn) -> Void in
                        self.clickButton(btn as! ItemView)
                    })
                    buttonItem3.button.setBackgroundImage(UIImage(named: "smallBubble3"), forState: UIControlState.Normal)
                    buttonItem3.startCenter = pStartCenter;
                    buttonItem3.endCenter = CGPointMake(buttonItem3.startCenter.x - (fBigCircleD / 2 + fSmallRectD_Mid / 2), buttonItem3.startCenter.y)
                    buttonItem3.farCenter = CGPointMake(buttonItem3.endCenter.x - spaceFar, buttonItem3.endCenter.y)
                    
                    buttonItem3.center = buttonItem3.startCenter
                    self.insertSubview(buttonItem3, belowSubview: buttonItem0)
                    buttonItem3.hidden = true
                    buttonItem3.tag = ButtonType.ButtonType_LeftMid.rawValue
                    self.itemsAry .addObject(buttonItem3)
                
                
                    /**************************************** rightMid button ******************************************************/
                    if (itemsNum > 4) {
                        var ps4 = CGPointMake((CGRectGetWidth(frameMid) - fSmallCircleD) / 2, CGRectGetHeight(frameMid) / 2)
                        var pe4 = CGPointMake(0, CGRectGetHeight(frameMid) / 2);
                        var buttonItem4 = ItemView(frame: frameMid, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps4, lineEnd: pe4, block: { (btn) -> Void in
                            self.clickButton(btn as! ItemView)
                        })
                        buttonItem4.button.setBackgroundImage(UIImage(named: "smallBubble4"), forState: UIControlState.Normal)
                        buttonItem4.startCenter = pStartCenter
                        buttonItem4.endCenter = CGPointMake(buttonItem4.startCenter.x + (fBigCircleD / 2 + fSmallRectD_Mid / 2), buttonItem4.startCenter.y)
                        buttonItem4.farCenter = CGPointMake(buttonItem4.endCenter.x + spaceFar, buttonItem4.endCenter.y)
                        buttonItem4.center = buttonItem4.startCenter
                        self.insertSubview(buttonItem4, belowSubview: buttonItem0)
                        buttonItem4.hidden = true
                        buttonItem4.tag = ButtonType.ButtonType_RightMid.rawValue
                        self.itemsAry .addObject(buttonItem4)
                    
                        /**************************************** leftUp button ******************************************************/
                        if (itemsNum > 5) {
                            
                            //leftup button
                            var ps5 = CGPointMake(CGRectGetWidth(frameUD) / 2 + CGFloat(cosf(Float(M_PI_4))) * fSmallCircleD / 2, CGRectGetHeight(frameUD) / 2 + CGFloat(sinf(Float(M_PI_4))) * fSmallCircleD / 2)
                            var pe5 = CGPointMake(CGRectGetWidth(frameUD), CGRectGetHeight(frameUD))
                            var buttonItem5 = ItemView(frame: frameUD, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps5, lineEnd: pe5, block: { (btn) -> Void in
                                self.clickButton(btn as! ItemView)
                            })
                            buttonItem5.button.setBackgroundImage(UIImage(named: "smallBubble5"), forState: UIControlState.Normal)
                            buttonItem5.startCenter = pStartCenter
                            buttonItem5.endCenter = CGPointMake((CGRectGetWidth(buttonItem5.button.bounds) / 2 + spaceW), CGRectGetHeight(buttonItem5.button.bounds) / 2 + spaceH)
                            buttonItem5.farCenter = CGPointMake(buttonItem5.endCenter.x - CGFloat(cosf(Float(M_PI_4))) * spaceFar, buttonItem5.endCenter.y - CGFloat(sinf(Float(M_PI_4))) * spaceFar)
                            buttonItem5.center = buttonItem5.startCenter
                            self.insertSubview(buttonItem5, belowSubview: buttonItem0)
                            buttonItem5.hidden = true
                            buttonItem5.tag = ButtonType.ButtonType_LeftUp.rawValue
                            self.itemsAry.addObject(buttonItem5)
                            
                            /**************************************** rightup button ******************************************************/
                            if (itemsNum > 6) {
                                var ps6 = CGPointMake(CGRectGetWidth(frameUD) / 2 - CGFloat(cosf(Float(M_PI_4))) * fSmallCircleD / 2, CGRectGetHeight(frameUD) / 2 + CGFloat(sinf(Float(M_PI_4))) * fSmallCircleD / 2)
                                var pe6 = CGPointMake(0, CGRectGetHeight(frameUD))
                                var buttonItem6 = ItemView(frame: frameUD, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps6, lineEnd: pe6, block: { (btn) -> Void in
                                    self.clickButton(btn as! ItemView)
                                })
                                buttonItem6.button.setBackgroundImage(UIImage(named: "smallBubble6"), forState: UIControlState.Normal)
                                buttonItem6.startCenter = pStartCenter
                                buttonItem6.endCenter = CGPointMake((CGRectGetWidth(self.bounds) - spaceW - CGRectGetWidth(buttonItem6.button.bounds) / 2), CGRectGetHeight(buttonItem6.button.bounds) / 2 + spaceH)
                                buttonItem6.farCenter = CGPointMake(buttonItem6.endCenter.x + CGFloat(cosf(Float(M_PI_4))) * spaceFar, buttonItem6.endCenter.y - CGFloat(sinf(Float(M_PI_4))) * spaceFar)
                                buttonItem6.center = buttonItem6.startCenter
                                self.insertSubview(buttonItem6, belowSubview: buttonItem0)
                                buttonItem6.hidden = true
                                buttonItem6.tag = ButtonType.ButtonType_RightUp.rawValue
                                self.itemsAry.addObject(buttonItem6)
                                
                                /**************************************** midUp button ******************************************************/
                                if (itemsNum > 7) {
                                    //midUp button
                                    var ps7 = CGPointMake(CGRectGetWidth(frameMid) / 2, (CGRectGetHeight(frameMid) - fSmallCircleD) / 2 + fSmallCircleD)
                                    var pe7 = CGPointMake(CGRectGetWidth(frameMid) / 2, CGRectGetHeight(frameMid))
                                    var buttonItem7 = ItemView(frame: frameMid, buttonFrame: CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow), lineStart: ps7, lineEnd: pe7, block: { (btn) -> Void in
                                        self.clickButton(btn as! ItemView)
                                    })
                                    buttonItem7.button.setBackgroundImage(UIImage(named: "smallBubble7"), forState: UIControlState.Normal)
                                    buttonItem7.startCenter = pStartCenter
                                    buttonItem7.endCenter = CGPointMake(buttonItem7.startCenter.x, buttonItem7.startCenter.y - (fBigCircleD / 2 + fSmallRectD_Mid / 2))
                                    buttonItem7.farCenter = CGPointMake(buttonItem7.endCenter.x, buttonItem7.endCenter.y - spaceFar)
                                    buttonItem7.center = buttonItem4.startCenter
                                    self.insertSubview(buttonItem7, belowSubview: buttonItem0)
                                    buttonItem7.hidden = true
                                    buttonItem7.tag = ButtonType.ButtonType_MidUp.rawValue
                                    itemsAry.addObject(buttonItem7)
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
        
        for (var i = 0; i < itemsNum; i++) {
            var item: ItemView = itemsAry.objectAtIndex(i) as! ItemView
            if (i != 0) {
                item.labelBottom.text = "Child\(i)"
                Utils.dealViewRoundCorners(item.button, radius: CGRectGetHeight(item.button.bounds)/2, borderWidth: 2)
            }
            var color = Utils.getColorByTag(self.tag)
            if item.labelTitle_Main != nil {
                item.labelTitle_Main.textColor = color
            }

            if (item.labelBottom != nil) {
                item.labelBottom.textColor = color
            }
            Utils.dealScaleView(item, scale: scaleNum)
        }
    }
    
    func setDetailsViewBlock(aBlock:(AnyObject) -> Void) {
        self.blockButton = aBlock
    }
    
    func setItemsTransform(transf:CGAffineTransform) {
        for (var i = 0;i <  itemsNum; i++) {
            var item = itemsAry.objectAtIndex(i) as! ItemView
            item.button.transform = transf
        }
    }
    
    func rotationView(aAngle:CGFloat) {
        var time = animationTime / 2
        var spaceNum = fabs(startAngle) + fabs(aAngle)
        if spaceNum > CGFloat(M_PI) {
            spaceNum = CGFloat(M_PI) - spaceNum
        }
        if spaceNum > CGFloat(M_PI_2) {
            time = animationTime
            if spaceNum > CGFloat(M_PI_2) + CGFloat(M_PI_4) {
                time = animationTime * 3 / 2
            }
        }
        startAngle = aAngle
        UIView.animateWithDuration(NSTimeInterval(time), animations: { () -> Void in
            var transform = CGAffineTransformMakeRotation(-aAngle)
            self.superview?.layer.anchorPoint = CGPointMake(0.5, 1)
            self.superview?.transform = transform
            var transformItem = CGAffineTransformMakeRotation(aAngle)
            self.setItemsTransform(transformItem)
        })
    }
    
    func animationOfRotationByTime(time:CGFloat, angle aAngle:CGFloat, delay delayTime:CGFloat) {
        
        UIView.animateWithDuration(NSTimeInterval(time), delay: NSTimeInterval(delayTime), options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            var transform = CGAffineTransformMakeRotation(-aAngle)
            self.superview?.layer.anchorPoint = CGPointMake(0.5, 1)
            self.superview?.transform = transform
            var transformItem = CGAffineTransformMakeRotation(aAngle)
            self.setItemsTransform(transformItem)
        }) { (finished) -> Void in
            
        }
    }
    
    func toAppearItemsViw(aPoint:CGPoint, angle aAngle:CGFloat) {
        startAngle = aAngle
        self.superview?.transform = CGAffineTransformIdentity
        var transform = CGAffineTransformMakeRotation(-aAngle)
        self.superview?.layer.anchorPoint = CGPointMake(0.5, 1)
        self.superview?.transform = transform
        self .setItemsTransform(CGAffineTransformIdentity)
        var transformItem = CGAffineTransformMakeRotation(aAngle)
        self.setItemsTransform(transformItem)
        self.appearItems();
    }
    
    func appearItems() {
        var buttonItem0 = itemsAry.objectAtIndex(0) as! ItemView
        self.appearItem(buttonItem0, delay: 0, ToFrontWhenCompletion: false)
        for (var i = 1; i < itemsNum; i++) {
            var item = itemsAry.objectAtIndex(i) as! ItemView
            item.hidden = false
            self.appearItem(item, delay: 0.2 + CGFloat(i-1) * 0.1, ToFrontWhenCompletion: true)
        }
    }
    
    func appearItem(item:ItemView, delay:CGFloat, ToFrontWhenCompletion bFont:Bool) {
        UIView.animateWithDuration(0.2, delay: NSTimeInterval(delay), options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            item.center = item.farCenter
            Utils.dealScaleView(item, scale: 1/self.scaleNum)
        }) { (finished) -> Void in
            if bFont {
                self.bringSubviewToFront(item)
            }
        }
    }
    
    func disapperItems(aBlock:() -> Void) {
        if selectItem != nil {
            selectItem = nil
            if self.flickerTimer != nil {
                self.flickerTimer.invalidate()
            }
            var imgView = self.viewWithTag(1000)
            imgView?.removeFromSuperview()
        }
        var buttonItem0 = itemsAry.objectAtIndex(0) as! ItemView
        if buttonItem0.center.x == buttonItem0.startCenter.x && buttonItem0.center.y == buttonItem0.startCenter.y {
            return
        }
        self.bringSubviewToFront(buttonItem0)
        if itemsNum == 1 {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                buttonItem0.center = buttonItem0.startCenter
                Utils.dealScaleView(buttonItem0, scale: self.scaleNum)
            }, completion: { (finished) -> Void in
                aBlock()
            })
        }else{
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                for (var i = 1; i < self.itemsNum; i++) {
                    var item = self.itemsAry.objectAtIndex(i) as! ItemView
                    item.center = item.startCenter
                    Utils.dealScaleView(item, scale: self.scaleNum)
                }
            }, completion: { (finished) -> Void in
                for (var i = 1; i < self.itemsNum; i++) {
                    var item = self.itemsAry.objectAtIndex(i) as! ItemView
                    item.hidden = true
                }
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    buttonItem0.center = buttonItem0.startCenter
                    Utils.dealScaleView(buttonItem0, scale: self.scaleNum)
                }, completion: { (finished) -> Void in
                    aBlock()
                })
            })
        }
        
    }
    
    func clickButton(btn: ItemView) {
        self.selectItem = btn
        self.blockButton(btn: self.selectItem)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
