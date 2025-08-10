//
//  ItemCarritoTableViewCell.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import UIKit
import SDWebImage

class ItemCarritoTableViewCell: UITableViewCell {
    


    @IBOutlet weak var imagenVino: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    
    @IBOutlet weak var stepperCantidad: UIStepper!

    
    var itemActual: CarritoItem?
    var onCantidadCambiada: ((Int) -> Void)?
    
    func configure(with item: CarritoItem) {
        itemActual = item
        nombreLabel.text = item.nombre
        precioLabel.text = String(format: "S/ %.2f", item.precio)
        cantidadLabel.text = "Cantidad: \(item.cantidad)"
        imagenVino.sd_setImage(with: URL(string: item.imagenURL), placeholderImage: UIImage(named: "placeholder"))

        stepperCantidad.value = Double(item.cantidad)
        stepperCantidad.minimumValue = 1
        stepperCantidad.stepValue = 1
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let nuevaCantidad = Int(sender.value)
        cantidadLabel.text = "Cantidad: \(nuevaCantidad)"
        onCantidadCambiada?(nuevaCantidad)
    }
}

