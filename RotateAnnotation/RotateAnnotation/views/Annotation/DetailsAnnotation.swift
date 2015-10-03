//
//  DetailsAnnotation.swift
//  RotateAnnotation
//
//  Created by user on 6/30/15.
//  Copyright (c) 2015 ken. All rights reserved.
//

import UIKit
import MapKit


class DetailsAnnotation: NSObject, MKAnnotation {
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    var tag:NSInteger = 0
    
    
    init(lat:CLLocationDegrees, andLongitude long:CLLocationDegrees) {
        super.init()
        latitude = lat
        longitude = long
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        set (newCoordinate){
            self.latitude = newCoordinate.latitude
            self.longitude = newCoordinate.longitude
        }
    }
}
