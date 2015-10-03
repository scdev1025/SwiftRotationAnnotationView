//
//  PinAnnotationView.swift
//  RotateAnnotation
//
//  Created by user on 6/30/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotationView: MKAnnotationView {

    var imgView:UIImageView!
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.canShowCallout = false
        self.frame = CGRectMake(0, 0, kPinAnnotationSize, kPinAnnotationSize)
        self.imgView = UIImageView(image: UIImage(named: "dot"))
        self.imgView.frame = self.bounds
        self .addSubview(self.imgView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
