//
//  API.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 10/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

protocol IBGEManagementDelegate {
    func didFailWithError(_ error: Error)
    func didLoadUFs(_ ufs: [String])
    func didLoadCities(_ cities: [String])
}

struct IBGEManagement {
    
    let baseURL = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"
    
    var delegate: IBGEManagementDelegate?
    
    func fetchUFs() {
        fetch(url: baseURL) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error!)
            }
            
            do {
                let response = try JSONDecoder().decode(UF.self, from: data!)
                let ufArray = response.map { $0.sigla }.sorted()
                self.delegate?.didLoadUFs(ufArray)
                print("retorno")
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func fetchCities(forUF selectedUF: String) {
        let urlString = "\(baseURL)/\(selectedUF)/distritos"
        fetch(url: urlString) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error!)
            }
            
            do {
                let response = try JSONDecoder().decode(City.self, from: data!)
                let cityArray = response.map { $0.nome }.sorted()
                self.delegate?.didLoadCities(cityArray)
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
