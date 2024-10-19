//
//  HomeViewModel.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import Foundation
import InnovaFinalAPI

protocol HomeViewModelProtocol {
    
    var delegate: HomeViewModelDelegate? { get set }
    var product: [Product] { get }
    var numberOfItems: Int { get }
    var filteredNumberOfItems: Int { get }
    
    func viewDidLoad()
    func filteredProduct(key: String)
    func getProductDetailID(index: Int) -> Int
    func getFilteredProductDetailID(index: Int) -> Int
    func getProductImage(index: Int, isFiltered: Bool) -> String?
    func getProductName(index: Int, isFiltered: Bool) -> String?
    func getProductPrice(index: Int, isFiltered: Bool) -> Int?
    func getProductBrand(index: Int, isFiltered: Bool) -> String?
    func getProductCategory(index: Int, isFiltered: Bool) -> String?
    func product(_ index: Int) -> Product?
    func filteredProduct(_ index: Int) -> Product?
    func fetchData()
}

protocol HomeViewModelDelegate: AnyObject {
    
    func setupCollectionView()
    func setupSearchBar()
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class HomeViewModel: NSObject {
    
    static let shared = HomeViewModel(service: HomeService())
    
    let service: HomeServiceProtocol
    weak var delegate: HomeViewModelDelegate?
    private var homeProducts: [Product] = []
    private var filteredHomeProducts: [Product] = []
    
    init(service: HomeServiceProtocol) {
        self.service = service
    }
    
    fileprivate func fetchProduct() {
        
        self.delegate?.showLoadingView()
        
        service.fetchHomeProducts { [weak self] response in
            
            guard let self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.delegate?.hideLoadingView()
            })
          
            
            switch response {
            case .success(let product):
                homeProducts = product
                DispatchQueue.main.async {
                              self.delegate?.reloadData()
                          }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func getProductImage(index: Int, isFiltered: Bool) -> String? {
        return isFiltered ? filteredHomeProducts[index].image : homeProducts[index].image
    }
    
    func getProductName(index: Int, isFiltered: Bool) -> String? {
        return isFiltered ? filteredHomeProducts[index].name : homeProducts[index].name
    }
    
    func getProductPrice(index: Int, isFiltered: Bool) -> Int? {
        return isFiltered ? filteredHomeProducts[index].price : homeProducts[index].price
    }
    
    func getProductBrand(index: Int, isFiltered: Bool) -> String? {
        return isFiltered ? filteredHomeProducts[index].brand : homeProducts[index].brand
    }
    
    func getProductCategory(index: Int, isFiltered: Bool) -> String? {
        return homeProducts[index].category?.rawValue
    }

    var filteredNumberOfItems: Int {
        filteredHomeProducts.count
    }
    
    var numberOfItems: Int {
        homeProducts.count
    }
    
    var product: [Product] {
        homeProducts
    }
    
    func viewDidLoad() {
        self.fetchData()
        self.delegate?.setupCollectionView()
        self.delegate?.setupSearchBar()
    }
    
    func filteredProduct(_ index: Int) -> Product? {
        filteredHomeProducts[index]
    }
    
    func filteredProduct(key: String) {
        
        guard key.count >= 3 else { return }
        
        filteredHomeProducts = homeProducts.filter { product in
            
            guard let productName = product.name else { return false }
            
            return productName.lowercased().contains(key.lowercased())
        }
    }
    
    func getProductDetailID(index: Int) -> Int {
        return homeProducts[index].id ?? 111
    }
    
    func getFilteredProductDetailID(index: Int) -> Int {
        return filteredHomeProducts[index].id ?? 111
    }
    
    func product( _ index: Int) -> Product? {
         homeProducts[index + 3]
    }
    
    func fetchData() {
        fetchProduct()
    }
}
