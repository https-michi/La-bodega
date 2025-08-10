//
//  VinoTableViewCell.swift
//  LaBodega
//
//  Created by jos on 6/05/25.
//

import UIKit

class VinoTableViewCell: UITableViewCell {

        @IBOutlet weak var vinoImageView: UIImageView!
        @IBOutlet weak var nombreLabel: UILabel!
        @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
