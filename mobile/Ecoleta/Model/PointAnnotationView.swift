//
//  PointAnnotationView.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 15/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import UIKit
import MapKit

class PointAnnotationView: MKAnnotationView {
    
    func configure(_ annotation: PointAnnotation) {
        self.image = annotation.image
        self.bounds = CGRect(x: 0, y: 0, width: 90, height: 70)
        
        if self.subviews.count == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 45, width: 90, height: 25))
            view.backgroundColor = UIColor(red: 0.20, green: 0.80, blue: 0.47, alpha: 1.00)

            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
            label.font = label.font.withSize(13)
            label.textAlignment = .center
            label.baselineAdjustment = .alignCenters
            label.textColor = .white
            
            view.addSubview(label)
            self.addSubview(view)
        }
        
        if let label = self.subviews[0].subviews[0] as? UILabel {
            label.text = annotation.title
        }        
        
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
}
