//
//  ItemView.swift
//  RotateAnnotation
//
//  Created by user on 6/30/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit

enum ItemButtonType:Int {
    case ItemButtonType_Main = 0,
    ItemButtonType_Left,
    ItemButtonType_right
}

class ItemView: UIView {
    var title:String!
    var type:String!
    
    var blockButton: (btn:AnyObject) -> Void = {(AnyObject) in }
    
    var button:UIButton!
    var labelBottom:UILabel!
    var labelTitle_Main:UILabel!
    var angleStart:CGFloat = 0
    var angleEnd:CGFloat = 0
    var lineStartP:CGPoint = CGPointZero
    var lineEndP:CGPoint = CGPointZero
    var startCenter:CGPoint = CGPointZero
    var endCenter:CGPoint = CGPointZero
    var farCenter:CGPoint = CGPointZero
    
    init(frame:CGRect, buttonFrame frameBtn:CGRect, lineStart p1:CGPoint, lineEnd p2:CGPoint, block aBlock:(AnyObject) -> Void) {
        //init
        super.init(frame: frame)
        
        blockButton = aBlock
        self.backgroundColor = UIColor.clearColor()
        lineStartP = p1
        lineEndP = p2
        button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = frameBtn
        button.center = self.center
        button.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(button)
        button.addTarget(self, action: Selector("clickButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        if CGRectGetHeight(frame) == 260 {
            if labelBottom != nil {
                labelBottom.hidden = true
            }
            labelTitle_Main = UILabel(frame: CGRectMake(0, CGRectGetHeight(self.button.bounds)/2+10, CGRectGetWidth(self.button.bounds)-40, 20))
            labelTitle_Main.center = CGPointMake(CGRectGetWidth(self.button.bounds)/2, CGRectGetHeight(self.button.bounds)/2)
            labelTitle_Main.textColor = Utils.getColorByTag(self.tag)
            labelTitle_Main.textAlignment = NSTextAlignment.Center
            labelTitle_Main.font = UIFont.systemFontOfSize(15)
            labelTitle_Main.backgroundColor = UIColor.clearColor()
            button .addSubview(labelTitle_Main)
        }else{
            labelBottom = UILabel()
            var labelFrame = CGRectMake(0, 0, CGRectGetWidth(frameBtn), 14)
            labelBottom.frame = labelFrame
            labelBottom.center = CGPointMake(CGRectGetWidth(self.button.bounds)/2, CGRectGetHeight(self.button.bounds)/2)
            labelBottom.textAlignment = NSTextAlignment.Center
            labelBottom.font = UIFont.systemFontOfSize(10)
            labelBottom.textColor = Utils.getColorByTag(self.tag)
            labelBottom.backgroundColor = UIColor.clearColor()
            button.addSubview(labelBottom)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        if (lineEndP.x == lineStartP.x && lineStartP.y == lineEndP.y) {
            return;
        }
        drawInContext(UIGraphicsGetCurrentContext())
    }
    
    func drawInContext(context:CGContextRef) {
        CGContextSetLineWidth(context,1)
        CGContextMoveToPoint(context, self.lineStartP.x, self.lineStartP.y)
        CGContextAddLineToPoint(context, self.lineEndP.x, self.lineEndP.y)
        CGContextStrokePath(context)
    }
    
    @IBAction func clickButton(sender:AnyObject) {
        blockButton(btn: self)
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
