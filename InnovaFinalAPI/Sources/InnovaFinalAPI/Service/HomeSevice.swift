//
//  HomeService.swift
//  InnovaFinalAPI
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import Foundation
import Alamofire

public protocol HomeServiceProtocol: AnyObject {
    
    func isConnectedToInternet() -> Bool
    func fetchHomeProducts(completion: @escaping (Result<[Product],Error>) -> Void)
}

public class HomeService: HomeServiceProtocol {
  
    public init () { }
    
    public func isConnectedToInternet() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    public func fetchHomeProducts(completion: @escaping (Result<[Product],Error>) -> Void) {
        
        let urlString = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"

        AF.request(urlString).responseData { response in
            switch response.result {
            case.success(let data):

                let decoder = Decoders.dateDecoder

                do {
                    let response = try decoder.decode(HomeResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure(error))
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
