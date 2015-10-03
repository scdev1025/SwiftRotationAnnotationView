//
//  Global.swift
//  RotateAnnotation
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit

let kTabBarHeight = 45.0
let kEverLaunched = "everlaunched"
let kFirstLanched = "firstLaunched"

let kPinAnnotationSize:CGFloat = 30.0

func DLog(format: String!, args: CVaListPointer) {
    NSLogv(format, args)
}

func MyAppDelegate() -> AppDelegate {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    return appDelegate
}