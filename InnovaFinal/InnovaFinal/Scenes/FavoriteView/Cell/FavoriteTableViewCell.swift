//
//  FavoriteTableViewCell.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 14.10.2024.
//

import UIKit
import InnovaFinalAPI
import SDWebImage

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let reuseIdentifier = String(describing: FavoriteTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(product: ProductsEntity) {
        brandLabel.text = product.productBrand
        nameLabel.text = product.productName
        priceLabel.text = "\(String(describing: product.productPrice)) TL"
        
        DispatchQueue.main.async {
            self.setImage(image: product.productImage ?? "")
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
