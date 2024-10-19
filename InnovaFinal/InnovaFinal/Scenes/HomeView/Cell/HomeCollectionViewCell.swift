//
//  HomeCollectionViewCell.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import UIKit
import InnovaFinalAPI
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let reuseIdentifier = String(describing: HomeCollectionViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(product: Product) {
        
        DispatchQueue.main.async {
            self.setImage(product: product)
        }
        
        if let name = product.name {
            nameLabel.text = name
        } else {
            nameLabel.text = ""
        }
        
        if let brand = product.brand {
            brandLabel.text = brand
        } else {
            brandLabel.text = ""
        }
        
        if let price = product.price {
            priceLabel.text = "₺\(price)"
        } else {
            priceLabel.text = ""
        }
        if let category = product.category {
            categoryLabel.text = "\(category)"
        } else {
            categoryLabel.text = ""
        }
    }

    func setImage(product: Product) {
        
        guard let imageName = product.image else { return }
        
        let fullPath = "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)"
       
        if let url = URL(string: fullPath) {
            productImageView.sd_setImage(with: url)
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
}
