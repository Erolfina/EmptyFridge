//
//  ListTableViewCell.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-11.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var listLabel: UILabel!
    
    // MARK: - Cycle View
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func configureCell(list: String) {
        listLabel.text = list
    }
}
