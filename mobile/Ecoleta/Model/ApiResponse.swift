//
//  ItemResponse.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 12/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

struct ItemObject: Decodable {
    let id: Int?
    let title: String
    let image_url: String?
}

typealias ItemResponse = [ItemObject]

struct PointObject: Decodable {
    let id: Int
    let name: String
    let email: String
    let whatsapp: String
    let latitude: String
    let longitude: String
    let city: String
    let uf: String
    let image_url: String
    let items: [ItemObject]?
}

typealias PointResponse = [PointObject]
