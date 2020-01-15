//
//  Place.swift
//  Map Demo
//
//  Created by Mohammad Kiani on 2020-01-09.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D
    
    init( coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
    }
    
    
}

