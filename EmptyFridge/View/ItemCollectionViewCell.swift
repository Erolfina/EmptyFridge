//
//  ItemCollectionViewCell.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-13.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantityItemLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Configure bordure autour de la cellule
        let borderColor = UIColor(named: "mainYellow")
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    //MARK: - Public Methods
    func configureItemCell(label: String, quantity:Int, imageName: String) {
    //configure l'interieur de la cellule
        labelCell.text = label
        quantityItemLabel.text = String(quantity)
        imageCell.image = UIImage(named: imageName)

    }
}
