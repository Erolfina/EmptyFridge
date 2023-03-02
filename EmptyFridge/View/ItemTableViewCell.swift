//
//  ItemTableViewCell.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-11.
//

import Foundation
import UIKit

class ItemTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    // MARK: - CycleView
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func configureItemCell(label: String, itemQuantity: String, imageName: String) {
        itemLabel.text = label
        quantityLabel.text = String(itemQuantity)
        itemImage.image = UIImage(named: imageName)
    }
}
