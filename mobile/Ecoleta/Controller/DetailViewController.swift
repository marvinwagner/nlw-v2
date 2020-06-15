//
//  DetailViewController.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 15/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    var api = ApiManagement()
    
    var pointId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        imageView.layer.cornerRadius = 10
        
        whatsappButton.setImage(UIImage(systemName: "message"), for: .normal)
        whatsappButton.imageView?.contentMode = .scaleAspectFit
        whatsappButton.tintColor = .white
        whatsappButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        whatsappButton.layer.cornerRadius = 10
        
        emailButton.setImage(UIImage(systemName: "envelope"), for: .normal)
        emailButton.imageView?.contentMode = .scaleAspectFit
        emailButton.tintColor = .white
        emailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        emailButton.layer.cornerRadius = 10
        
        api.delegate = self
        api.fetchPoint(for: pointId ?? 0)
    }
}

extension DetailViewController: ApiManagementDelegate {
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func didLoadItems(_ items: [ItemData]) { }
    
    func didLoadPoints(_ points: [PointObject]) { }
    
    func didLoadPoint(_ point: PointObject) {
        DispatchQueue.main.async {
            //self.imageView = point.image_url
            self.imageView.kf.setImage(with: URL(string: point.image_url))
            self.nameLabel.text = point.name
            self.itemsLabel.text = point.items!.map { $0.title }.joined(separator: ", ")
            self.enderecoLabel.text = "\(point.city), \(point.uf)"
        }
    }    
}
