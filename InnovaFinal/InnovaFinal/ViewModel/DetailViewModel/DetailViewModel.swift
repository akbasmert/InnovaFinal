//
//  DetailViewModel.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import Foundation
import InnovaFinalAPI
import SDWebImage

protocol DetailViewModelProtocol {
    
    var delegate: DetailViewModelDelegate?  { get set }
    func viewDidLoad()
    
    func checkProductData(
        id: Int,
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    )
    func isSavedProductId(productId: Int) -> Bool
    func getImage(imageName: String) -> UIImage?
    func saveProduct(
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    )
}

protocol DetailViewModelDelegate: AnyObject {
    
    func setNumberOfProducts()
    func setBrandOfProducts()
    func setNameOfProducts()
    func setTotalPriceOfProducts()
    func setPriceOfProducts()
    func setImage()
}

final class DetailViewModel: NSObject {
    
    static let shared = DetailViewModel(service: DetailService())
    let  service: DetailServiceProtocol
    weak var delegate: DetailViewModelDelegate?
    private var product: Product?
    
    init(service: DetailServiceProtocol) {
        self.service = service
    }
    
    func saveAddProduct(
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    ) {
        service.addProduct(
            name: name,
            image: image,
            category: category,
            price: price,
            brand: brand,
            productNumber: productNumber
        ) { result in
            switch result {
            case .success(let isSuccessful):
                print(isSuccessful)
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func saveProduct(
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    ) {
        saveAddProduct(
            name: name,
            price: price,
            image: image,
            brand: brand,
            category: category,
            productNumber: productNumber
        )
    }
    
    func viewDidLoad() {
        self.delegate?.setImage()
        self.delegate?.setNumberOfProducts()
        self.delegate?.setNameOfProducts()
        self.delegate?.setPriceOfProducts()
        self.delegate?.setBrandOfProducts()
        self.delegate?.setTotalPriceOfProducts()
    }
    
    func getImage(imageName: String) -> UIImage? {
        let fullPath = "http://kasimadalan.pe.hu/urunler/resimler/\(imageName)"
        
        if let cachedImage = SDImageCache.shared.imageFromDiskCache(forKey: fullPath) {
            return cachedImage
        }
        return UIImage(systemName: "photo") ?? UIImage()
    }
    
    func isSavedProductId(productId: Int) -> Bool {
        let audioData = CoreDataManager.shared.fetchProductData()
        return audioData.contains { $0.id == productId }
    }
    
    func checkProductData(
        id: Int,
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    ) {
        
        let productEntities = CoreDataManager.shared.fetchProductData()
        let existingProductEntity = productEntities.first { $0.id == Int64(id) }
        
        if let existingProductEntity = existingProductEntity {
            
            CoreDataManager.shared.deleteProductData(
                withID: Int(existingProductEntity.id)
            )
        } else {
            CoreDataManager.shared.saveProductData(
                id: id,
                name: name,
                price: price,
                image: image,
                brand: brand,
                category: category,
                productNumber: productNumber
            )
        }
    }
}
