//
//  MapMarkerOverlay.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 15/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation
import MapKit

class PointAnnotation: MKPointAnnotation {
    
    var image: UIImage?
    var pointId: Int = 0

    init(point: PointObject) {
        super.init()
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: Double(point.latitude)!, longitude: Double(point.longitude)!)
        
        self.pointId = point.id
        self.coordinate = centerCoordinate
        self.title = point.name
        self.coordinate = CLLocationCoordinate2D(latitude: Double(point.latitude)!, longitude: Double(point.longitude)!)
        
        if let url = URL(string: point.image_url) {
            if let data = try? Data(contentsOf: url) {
                self.image = UIImage(data: data)
            }
        }
    }
}
