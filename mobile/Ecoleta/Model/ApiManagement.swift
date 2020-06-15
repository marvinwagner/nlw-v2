//
//  API.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 10/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

protocol ApiManagementDelegate {
    func didFailWithError(_ error: Error)
    func didLoadItems(_ items: [ItemData])
    func didLoadPoints(_ points: [PointObject])
    func didLoadPoint(_ point: PointObject)
}

struct ApiManagement {
    
    let itemsURL = "http://192.168.15.5:3333/items"
    let pointsURL = "http://192.168.15.5:3333/points"
    
    var delegate: ApiManagementDelegate?
    
    func fetchItems() {
        fetch(url: itemsURL) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error!)
            }
            if data == nil {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ItemResponse.self, from: data!)
                let items = response.map { ItemData(id: $0.id!, name: $0.title, imageUrl: $0.image_url!) }
                self.delegate?.didLoadItems(items)
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func fetchPoints(for items: [Int], uf: String, city: String) {
        let ids = items.map { String($0) }
        let url = "\(pointsURL)?city=\(city)&uf=\(uf)&items=\(ids.joined(separator: ","))"
        fetch(url: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error!)
            }
            if data == nil {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PointResponse.self, from: data!)
                self.delegate?.didLoadPoints(response)
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func fetchPoint(for id: Int) {
        let url = "\(pointsURL)/\(id)"
        fetch(url: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error!)
            }
            if data == nil {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PointObject.self, from: data!)
                self.delegate?.didLoadPoint(response)
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    private func fetch(url: String, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: callback)
            task.resume()
        }
    }
}
