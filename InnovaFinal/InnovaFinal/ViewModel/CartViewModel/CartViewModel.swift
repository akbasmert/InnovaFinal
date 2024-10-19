//
//  CartViewModel.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 11.10.2024.
//

import Foundation
import InnovaFinalAPI

protocol CartViewModelProtocol {
    
    var delegate: CartViewModelDelegate? { get set }
    var products: [Product] { get }
    var numberOfItems: Int { get }
    
    func getProduct(_ index: Int) -> Product?
    func viewDidLoad()
    func fetchProducts()
    func deleteProducts(name: String)
    func deleteAllProducts()
    
    func getName(index: Int) -> String?
    func getImage(for productName: String) -> String?
    func getCategoryName(for productName: String) -> String?
    func getBrandName(for productName: String) -> String?
    func getPrice(for productName: String) -> Int?
    func getTotalProductNumber(for productName: String) -> Int
    func getTotalProductsNumber() -> Int
    func getCartIds(for productName: String) -> [Int]
    func getAllIds() -> [Int]
}

protocol CartViewModelDelegate: AnyObject {
    
    func setupTableView()
    func setPriceLabel()
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class CartViewModel: NSObject {
    
    static let shared = CartViewModel(service: CartService())
    
    let service: CartServiceProtocol
    weak var delegate: CartViewModelDelegate?
    internal var products: [Product] = []
    internal var uniqueProductNames: [String] = []
    
    init(service: CartServiceProtocol) {
        self.service = service
    }
    
    internal func fetchCartProducts() {
        
        self.delegate?.showLoadingView()
        
        service.fetchCartProducts { [weak self] response in
            
            guard let self else { return }
            
            self.delegate?.hideLoadingView()
            
            switch response {
                
            case .success(let product):
                
                products = product
                generateUniqueProductNames()
                delegate?.setPriceLabel()
                
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
                
            case .failure(_):
                
                products.removeAll()
                generateUniqueProductNames()
                delegate?.setPriceLabel()
                
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
            }
        }
    }
    
    internal func deleteProducts(cartIds: [Int]) {
        
        self.delegate?.showLoadingView()
        
        let group = DispatchGroup()
        for cartId in cartIds {
            group.enter()
            service.deleteProduct(cartId: cartId) { result in
                switch result {
                    
                case .success(let isSuccessful):
                    print(isSuccessful)
                case .failure(let error):
                    print("Hata: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.delegate?.hideLoadingView()
            self.fetchProducts()
        }
    }
    
    func generateUniqueProductNames() {
        var seenNames: [String] = []
        
        for product in products {
            if let name = product.name, !seenNames.contains(name) {
                seenNames.append(name)
            }
        }
        uniqueProductNames = seenNames
    }
}

extension CartViewModel: CartViewModelProtocol {
    
    func getProduct(_ index: Int) -> InnovaFinalAPI.Product? {
        products[index]
    }
    
    var numberOfItems: Int {
        uniqueProductNames.count
    }
    
    func viewDidLoad() {
        self.fetchProducts()
        delegate?.setupTableView()
    }
    
    func fetchProducts() {
        fetchCartProducts()
    }
    
    func deleteProducts(name: String) {
        deleteProducts(cartIds: getCartIds(for: name))
    }
    
    func deleteAllProducts() {
        deleteProducts(cartIds: getAllIds())
    }
    
    func getName(index: Int) -> String? {
        uniqueProductNames[index]
    }
    
    func getImage(for productName: String) -> String? {
        for product in products {
            if product.name == productName {
                return product.image
            }
        }
        return nil
    }
    
    func getCategoryName(for productName: String) -> String? {
        for product in products {
            if product.name == productName {
                return product.category?.rawValue
            }
        }
        return nil
    }
    
    func getBrandName(for productName: String) -> String? {
        for product in products {
            if product.name == productName {
                return product.brand
            }
        }
        return nil
    }
    
    func getPrice(for productName: String) -> Int? {
        for product in products {
            if product.name == productName {
                return product.price
            }
        }
        return nil
    }
    
    func getTotalProductNumber(for productName: String) -> Int {
        var totalProductNumber = 0
        
        for product in products {
            if product.name == productName {
                totalProductNumber += product.productNumber ?? 0
            }
        }
        return totalProductNumber
    }
    
    func getCartIds(for productName: String) -> [Int] {
        var cartIds: [Int] = []
        
        for product in products {
            if product.name == productName {
                if let cartId = product.cartId {
                    cartIds.append(cartId)
                }
            }
        }
        return cartIds
    }
    
    func getAllIds() -> [Int] {
        var allIds: [Int] = []
        
        for product in products {
            if let cartId = product.cartId {
                allIds.append(cartId)
            }
        }
        return allIds
    }
    
    func getTotalProductsNumber() -> Int {
        var totalPrice = 0
        
        for product in products {
            
            let price = product.price ?? 0
            let quantity = product.productNumber ?? 0

            totalPrice += price * quantity
        }
        return totalPrice
    }
}
