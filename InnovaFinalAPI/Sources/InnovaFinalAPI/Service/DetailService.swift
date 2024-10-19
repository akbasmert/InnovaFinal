//
//  DetailServiceProtocol.swift
//  InnovaFinalAPI
//
//  Created by Mert AKBAŞ on 11.10.2024.
//

import Alamofire

public protocol DetailServiceProtocol: AnyObject {
    
    func addProduct(
        name: String,
        image: String,
        category: String,
        price: Int,
        brand: String,
        productNumber: Int,
        completion: @escaping (Result<Bool, Error>) -> Void)
}

public class DetailService: DetailServiceProtocol {
    
    public init() { }
    
    public func addProduct(
        name: String,
        image: String,
        category: String,
        price: Int,
        brand: String,
        productNumber: Int,
        completion: @escaping (Result<Bool, Error>) -> Void) {
        let urlString = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        
        let parameters: [String: Any] = [
            "ad": name,
            "resim": image,
            "kategori": category,
            "fiyat": price,
            "marka": brand,
            "siparisAdeti": productNumber,
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
                
                print("Ürün eklenirken hata: \(error)")
                completion(.failure(error))
            }
        }
    }
}

