//
//  UFResponse.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 11/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

class UFElement: Codable {
    let sigla: String
}

typealias UF = [UFElement]

class CityElement: Codable {
    let nome: String
}

typealias City = [CityElement]
