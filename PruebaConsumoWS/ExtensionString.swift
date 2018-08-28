//
//  ExtensionString.swift
//  PruebaConsumoWS
//
//  Created by Erick Alberto García Márquez on 28/08/18.
//  Copyright © 2018 Erick Alberto Garcia Marquez. All rights reserved.
//

import UIKit

extension String {
    func formatoDePrecio() -> String {
        let doubleString = Double(self)
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let priceString = currencyFormatter.string(from: doubleString! as NSNumber)!
        return priceString
    }
}
