//
//  MarketViewController.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 11/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Kingfisher

final class PointViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var itemsCollection: UICollectionView!
    
    var selectedUF: String?
    var selectedCity: String?
    var selectedPointId: Int = 0
    
    var itemDataArray = [ItemData]()
    var pointDataArray = [PointObject]()
    
    var api = ApiManagement()
    let locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.delegate = self
        itemsCollection.dataSource = self
        itemsCollection.delegate = self
        
        itemsCollection.register(UINib(nibName: K.cellItemNibName, bundle: nil), forCellWithReuseIdentifier: K.cellItemName)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 120)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        itemsCollection.collectionViewLayout = flowLayout
        itemsCollection.allowsMultipleSelection = true

        api.fetchItems()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.delegate = self
    }
    
    func filter() {
        let items = itemDataArray.filter { $0.selected }.map { $0.id }
        print(items)
        api.fetchPoints(for: items, uf: selectedUF!, city: selectedCity!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.tintColor = #colorLiteral(red: 0.2246646881, green: 0.8201124072, blue: 0.5479601026, alpha: 1)
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        // colocar o icone nas duas propriedades é obrigatório para substituir o icone padrão
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        
        if let detail = segue.destination as? DetailViewController {
            detail.pointId = selectedPointId
        }
    }
}

extension PointViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? PointAnnotation {
            selectedPointId = annotation.pointId

            performSegue(withIdentifier: K.segueGoToDetail, sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        var pointView = view as? PointAnnotationView
        
        if pointView == nil {
            pointView = PointAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let annotation = annotation as? PointAnnotation {
            pointView?.configure(annotation)
        }
        
        return pointView
    }
    
}

//MARK: - CLLocationManagerDelegate
extension PointViewController: CLLocationManagerDelegate {
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // Faz com que a proxima requisição de localização chame o didUpdateLocations

            let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
         }
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }
 }


extension PointViewController: ApiManagementDelegate {
    func didLoadPoint(_ point: PointObject) { }
    
    func didLoadPoints(_ points: [PointObject]) {
        DispatchQueue.main.async {
            self.pointDataArray = points
            var annotations = [MKPointAnnotation]()
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for point in points {
                let annotation = PointAnnotation(point: point)
                annotations.append(annotation)
            }
            
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func didLoadItems(_ items: [ItemData]) {
        DispatchQueue.main.async {
            self.itemDataArray = items
            self.itemsCollection.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - UICollectionViewDataSource methods
extension PointViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellItemName, for: indexPath) as! FilterItemCollectionViewCell
        let item = itemDataArray[indexPath.row]
        let url = URL(string: item.imageUrl)
        
        cell.cellImage.kf.setImage(with: url)
        cell.cellImage.image = drawPDFfromURL(url: url!)
        cell.cellText.text = item.name
        
        return cell
    }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.clear.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
}

//MARK: - UICollectionViewDelegate methods
extension PointViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        
        let cell = collectionView.cellForItem(at: indexPath) as! FilterItemCollectionViewCell
        cell.selectCell()
        
        itemDataArray[indexPath.row].selected = true
        filter()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
                
        let cell = collectionView.cellForItem(at: indexPath) as! FilterItemCollectionViewCell
        cell.deselectCell()
        
        itemDataArray[indexPath.row].selected = false
        filter()
    }
}
