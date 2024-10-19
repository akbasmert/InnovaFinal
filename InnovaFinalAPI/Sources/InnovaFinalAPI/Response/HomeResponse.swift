//
//  HomeResponse.swift
//  InnovaFinalAPI
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

public struct HomeResponse: Decodable {
    
    public let results: [Product]
    
    private enum RootCodingKeys: String, CodingKey {
        case results = "urunler" 
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.results = try container.decode([Product].self, forKey: .results)
    }
}
