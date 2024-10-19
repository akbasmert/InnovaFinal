//
//  NoDataTableViewCell.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 12.10.2024.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

    @IBOutlet weak var noDataLabel: UILabel!
    static let reuseIdentifier = String(describing: NoDataTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
