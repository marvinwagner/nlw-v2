//
//  API.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 10/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

struct NetworkManagement {
    
    let baseURL = "https://servicodados.ibge.gov.br/api/v1/localidades/estados"
    
    func fetchUFs() {
        if let url = URL(string: baseURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil || data == nil {
                    return
                }
                
                //decode
                do {
                    let response = try JSONDecoder().decode(UF.self, from: data!)
                    let ufArray = response.map { $0.sigla }
                } catch {
                    print(error.localizedDescription)
                }
                
                    
            }
            
            task.resume()
        }
    }
    
    func fetchCities(forUF selectedUF: String) {
        let urlString = "\(baseURL)/\(selectedUF)/distritos"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil || data == nil {
                    return
                }
                
                //decode
                do {
                    let response = try JSONDecoder().decode(UF.self, from: data!)
                    print(response)
                } catch {
                    
                }
                
                    
            }
            
            task.resume()
        }        
    }
}
