//
//  Utils.swift
//  RotateAnnotation
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit

enum ButtonType:Int{
    case ButtonType_Main = 0,
    ButtonType_LeftDown,
    ButtonType_RightDown,
    ButtonType_LeftMid,
    ButtonType_RightMid,
    ButtonType_LeftUp,
    ButtonType_RightUp,
    ButtonType_MidUp
}

func calculateRotateDegree(p1:CGPoint, p0:CGPoint) -> CGFloat {
    var rotateDegree = Double(atan2(fabs(p1.x-p0.x),fabs(p1.y-p0.y)) * 180) / M_PI
    if (p0.y<=p1.y)
    {
        if (p0.x<=p1.x)
        {
        }
        else
        {
            rotateDegree = -rotateDegree;
        }
    }
    else
    {
        if (p0.x<=p1.x)
        {
            rotateDegree = 180.0 - rotateDegree;
        }
        else
        {
            rotateDegree =  rotateDegree - 180;
        }
    }
    return CGFloat(rotateDegree * M_PI / Double(180))
}

class Utils: NSObject {
    class func heightOfText(text:String, theWidth width:CGFloat, theFont aFont:UIFont) -> CGSize {
        var result:CGFloat!
        var textSize = CGSize(width: width, height: 20000)
        var button:UIButton!
        var size:CGSize = NSString(string: text).boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : aFont], context: nil).size
        return size
    }
    
    class func dealViewRoundCorners(aView:UIView, radius aRadius:CGFloat, borderWidth aWidth:CGFloat) {
        aView.layer.masksToBounds = true
        aView.layer.cornerRadius = aRadius
        if aWidth > 0 {
            aView.layer.borderColor = UIColor.blackColor().CGColor
            aView.layer.borderWidth = aWidth
            aView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    class func dealScaleView(aView:UIView, scale aScale:CGFloat) {
        var currentTransform:CGAffineTransform = aView.transform
        var newTransform = CGAffineTransformScale(currentTransform, aScale, aScale)
        aView.transform = newTransform
    }
    
    class func getAngleByPoint(nowPoint:CGPoint, center:CGPoint) -> CGFloat {
        var angle:CGFloat = calculateRotateDegree(nowPoint, center)
        return angle
    }
    
    class func __newGlowGradientWithColor(color:UIColor) -> CGGradientRef {
        var cgColor:CGColorRef = color.CGColor
        let sourceColorComponents:UnsafePointer<CGFloat> = CGColorGetComponents(cgColor)
        
        
        var sourceRed:CGFloat
        var sourceGreen:CGFloat
        var sourceBlue:CGFloat
        var sourceAlpha:CGFloat
        if (CGColorGetNumberOfComponents(cgColor) == 2)
        {
            sourceRed = sourceColorComponents[0];
            sourceGreen = sourceColorComponents[0];
            sourceBlue = sourceColorComponents[0];
            sourceAlpha = sourceColorComponents[1];
        }
        else
        {
            sourceRed = sourceColorComponents[0];
            sourceGreen = sourceColorComponents[1];
            sourceBlue = sourceColorComponents[2];
            sourceAlpha = sourceColorComponents[3];
        }
        
        var locationsCount:size_t = 20
        var step:CGFloat = CGFloat(1) / CGFloat(locationsCount)
        var colorComponents = [CGFloat](count: 4 * locationsCount, repeatedValue: 0)
        var locations = [CGFloat](count: locationsCount, repeatedValue: 0)
        
        var componentsIndex:NSInteger = 0;
        for (var index:NSInteger = 0; index < locationsCount; index++)
        {
            var point:CGFloat = CGFloat(index) * step
            locations[index] = point;
            
            var alpha:CGFloat = sourceAlpha * (1 - 0.5 * (1 - cos(point * CGFloat(M_PI))))
            
            colorComponents[componentsIndex] = sourceRed;
            colorComponents[componentsIndex + 1] = sourceGreen;
            colorComponents[componentsIndex + 2] = sourceBlue;
            colorComponents[componentsIndex + 3] = alpha;
            componentsIndex += 4;
        }
        
        var colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        
        var gradient:CGGradientRef = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, locationsCount)
        return gradient;
    }
    
    class func getColorImage(size:CGSize, color:UIColor) -> UIImage {
        var glowSpread:CGFloat = 60
        var image:UIImage!
        var imageSize:CGSize = size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        CGContextSaveGState(context)
        
        var gradient:CGGradientRef = __newGlowGradientWithColor(color)
        
        var gradCenter:CGPoint = CGPointMake(floor(imageSize.width / 2), floor(imageSize.height / 2))
        var gradRadius:CGFloat = max(imageSize.width, imageSize.height) / 2
        
        CGContextDrawRadialGradient(context, gradient, gradCenter, CGFloat(0), gradCenter, gradRadius,  0)
        
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, glowSpread / 2, glowSpread / 2)
        
        CGContextRestoreGState(context);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        return image
    }
    class func colorWithHexString(stringToConvert:String) -> UIColor {
        var cString = stringToConvert.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        if count(cString) < 6 {
            return UIColor.redColor()
        }
        if cString.hasPrefix("0X") {
            cString = cString.substringFromIndex(advance(cString.startIndex, 2))
        }
        if cString.hasPrefix("#") {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        if count(cString) < 6 {
            return UIColor.redColor()
        }
        var startIndex:String.Index = cString.startIndex
        var endIndex = advance(startIndex, 2)
        var rString = cString.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
        startIndex = advance(startIndex, 2)
        endIndex = advance(startIndex, 2)
        var gString = cString.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
        startIndex = advance(startIndex, 2)
        endIndex = advance(startIndex, 2)
        var bString = cString.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
        var r = strtoul(String(rString), nil, 16)
        var g = strtoul(String(gString), nil, 16)
        var b = strtoul(String(bString), nil, 16)
        
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
    
    class func getColorByTag(tag:NSInteger) -> UIColor {
        var color:UIColor!
        switch tag {
        case 0:
            color = colorWithHexString("a72ee0")
        case 1:
            color = colorWithHexString("6445fc")
        case 2:
            color = colorWithHexString("295ed6")
        case 3:
            color = colorWithHexString("29a9de")
        case 4:
            color = colorWithHexString("2acadd")
        case 5:
            color = colorWithHexString("34dfbc")
        default:
            color = UIColor.blackColor()
        }
        return color
    }
    
}
