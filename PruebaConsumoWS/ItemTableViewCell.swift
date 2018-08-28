//
//  ItemTableViewCell.swift
//  PruebaConsumoWS
//
//  Created by Erick Alberto Garcia Marquez on 26/08/18.
//  Copyright © 2018 Erick Alberto Garcia Marquez. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblUbicacion: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
