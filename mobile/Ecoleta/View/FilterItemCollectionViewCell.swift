//
//  FilterItemCollectionViewCell.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 12/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import UIKit

class FilterItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderColor = CGColor(srgbRed: 0.73, green: 0.73, blue: 0.73, alpha: 1.00)
        self.layer.borderWidth = 2
    }

    func deselectCell() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.6
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
                self.backgroundColor = .white
                self.layer.cornerRadius = 8
                self.layer.borderColor = CGColor(srgbRed: 0.73, green: 0.73, blue: 0.73, alpha: 1.00)
                self.layer.borderWidth = 2
            })
        }
    }
    
    func selectCell() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.6
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
                self.backgroundColor = UIColor(red: 0.88, green: 0.98, blue: 0.93, alpha: 1.00)
                self.layer.cornerRadius = 8
                self.layer.borderColor = CGColor(srgbRed: 0.20, green: 0.80, blue: 0.47, alpha: 1.00)
                self.layer.borderWidth = 2
            })
        }
    }
}
