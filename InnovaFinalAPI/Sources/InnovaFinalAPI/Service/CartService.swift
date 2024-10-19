//
//  CartService.swift
//  InnovaFinalAPI
//
//  Created by Mert AKBAŞ on 11.10.2024.
//

import Foundation
import Alamofire

public protocol CartServiceProtocol: AnyObject {
    
    func fetchCartProducts(completion: @escaping (Result<[Product],Error>) -> Void)
    func deleteProduct(cartId: Int,completion: @escaping (Result<Bool, Error>) -> Void)
}

public class CartService: CartServiceProtocol {
    
    public init() { }
    
    public func fetchCartProducts(
        completion: @escaping (
            Result<[Product],
            Error>
        ) -> Void) {
            
            let urlString = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
            let params: Parameters = ["kullaniciAdi": "MERT_OZLE"]
            
            AF.request(
                urlString,
                method: .post,
                parameters: params
            ).response { response in
                
                if let data = response.data {
                    
                    do {
                        
                        let cevap = try JSONDecoder().decode(ProductCartResult.self, from: data)
                        
                        if let success = cevap.success, success == 1 {
                            
                            if let products = cevap.products {
                                
                                completion(.success(products))
                                
                            } else {
                                
                                let error = NSError(
                                    domain: "",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Ürün bulunamadı"]
                                )
                                
                                completion(.failure(error)
                                )
                            }
                            
                        } else {
                            
                            let error = NSError(
                                domain: "",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Sepet ürünleri getirilemedi"]
                            )
                            completion(.failure(error))
                        }
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                } else if let error = response.error {
                    
                    completion(.failure(error))
                }
            }
        }
    
    public func deleteProduct(
        cartId: Int,
        completion: @escaping (Result<Bool, Error>) -> Void) {
            let urlString = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
            
            let parameters: [String: Any] = [
                "sepetId": cartId,
                "kullaniciAdi": "MERT_OZLE"
            ]
            
            AF.request(
                urlString,
                method: .post,
                parameters: parameters,
                encoding: URLEncoding.default
            ).response { response in
                
                switch response.result {
                    
                case .success(_):
                    
                    completion(.success(true))
                    
                case .failure(let error):
                    
                    completion(.failure(error))
                }
            }
        }
}

