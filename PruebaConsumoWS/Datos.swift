//
//  Datos.swift
//  PruebaConsumoWS
//
//  Created by Erick Alberto Garcia Marquez on 28/08/18.
//  Copyright © 2018 Erick Alberto Garcia Marquez. All rights reserved.
//

import UIKit

struct DatosPrincipal: Codable {
    let contents: [DatosPrincipalContent]
}

struct DatosPrincipalContent: Codable {
    let mainContent: [MainContent]
}

struct MainContent: Codable {
    let name: String
    let contents: [MainContentContent]?
}

struct MainContentContent: Codable {
    let records: [Record]?
}

struct Record: Codable {
    let records: [Record]?
    let numRecords: Int
    let attributes: Attributes
}

struct Attributes : Codable {
    var smallImage : [String]
    var Title :[String]
    var Price :[String]
    enum CodingKeys: String, CodingKey {
        case smallImage = "sku.smallImage"
        case Title = "product.displayName"
        case Price = "sku.sale_Price"
    }
}

struct URLImages : Codable {
    var urlImg : String
}

struct DisplayNames : Codable {
    var Name : String
}

struct Prices : Codable {
    var Price : String
}
