//
//  PinAnnotation.swift
//  RotateAnnotation
//
//  Created by user on 6/30/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var title:String!
    var type:String!
    var tag:NSInteger = 0
    
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    init(lat:CLLocationDegrees, andLongitude lon:CLLocationDegrees) {
        super.init()
        self.latitude = lat
        self.longitude = lon
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
        
        set (newCoordinate){
            self.latitude = newCoordinate.latitude
            self.longitude = newCoordinate.longitude
        }
    }
}
