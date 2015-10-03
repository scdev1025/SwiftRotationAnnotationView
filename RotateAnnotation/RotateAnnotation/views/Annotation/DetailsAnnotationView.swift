//
//  DetailsAnnotationView.swift
//  RotateAnnotation
//
//  Created by user on 6/30/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit
import MapKit

class DetailsAnnotationView: MKAnnotationView {

    var cell:DetailsView!
    let Arror_height = 15
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.frame = CGRectMake(0, 0, 260, 260)
        self.cell = DetailsView.getInstanceWithNib()
        self.addSubview(self.cell)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCellUI(vo:MapItemInfoVO) {
        self.cell.tag = self.tag
        self.cell.setUI(vo)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
