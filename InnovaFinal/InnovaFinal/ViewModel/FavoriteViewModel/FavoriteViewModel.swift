//
//  FavoriteViewModel.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import Foundation
import InnovaFinalAPI

protocol FavoriteViewModelProtocol {
    
    var  delegate: FavoriteViewModelDelegate? { get set }
    var numberOfItems: Int { get }
   
    func checkProductData(
        id: Int,
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    )
    func saveFilteredProducts()
    func favoriteProduct(_ index: Int) -> ProductsEntity?
    func getProductId(index: Int) -> Int
    func viewDidLoad()
}

protocol FavoriteViewModelDelegate: AnyObject {
    
    func setupTableView()
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class FavoriteViewModel {
    
    static let shared = FavoriteViewModel(service: HomeService())
    let service: HomeServiceProtocol
    weak var delegate: FavoriteViewModelDelegate?
    
    private var productList: [ProductsEntity] = []
    private var filteredProducts: [Product] = []
    private var detailProduct: Product?
    
    init(service: HomeServiceProtocol) {
        self.service = service
    }
}

extension FavoriteViewModel: FavoriteViewModelProtocol {
  
    var numberOfItems: Int {
        return productList.count
    }
    
    func viewDidLoad() {
        delegate?.setupTableView()
    }
    
    func getProductId(index: Int) -> Int {
        return Int((productList[index].id ))
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
    
    func favoriteProduct(_ index: Int) -> ProductsEntity? {
        productList[index]
    }
    
    func saveFilteredProducts() {
        productList.removeAll()
        productList = CoreDataManager.shared.fetchProductData()
        self.delegate?.reloadData()
    }
}
