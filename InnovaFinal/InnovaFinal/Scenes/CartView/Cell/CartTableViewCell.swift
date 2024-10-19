//
//  CartTableViewCell.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 11.10.2024.
//

import UIKit
import InnovaFinalAPI
import SDWebImage

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(
        name: String?,
        brand: String?,
        price: Int?,
        number: Int?,
        image: String?
    ) {
        brandLabel.text = brand
        nameLabel.text = name
        priceLabel.text = "\(String(describing: price ?? 0)) TL"
        numberLabel.text = "\(String(describing: number ?? 0)) adet"
        
        let price = price
        let productNumber = number
        totalPriceLabel.text = "\((price ?? 0) * (productNumber ?? 0)) TL"
        
        DispatchQueue.main.async {
            self.setImage(image: image ?? "")
        }
    }
    
    func setImage(image: String) {
       
        let fullPath = "http://kasimadalan.pe.hu/urunler/resimler/\(image)"
       
        if let url = URL(string: fullPath) {
            productImageView.sd_setImage(with: url)
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }

}
