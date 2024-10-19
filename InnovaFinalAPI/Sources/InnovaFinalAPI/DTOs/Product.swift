//
//  File.swift
//  InnovaFinalAPI
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import Foundation

public struct ProductResult: Decodable {
    public let products: [Product]?
    public let success: Int?
    
    enum CodingKeys: String, CodingKey {
        case products = "urunler"
        case success
    }
}

public struct ProductCartResult: Decodable {
    public let success: Int?
    public let products: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case products = "urunler_sepeti"
    }
}

// MARK: - Product
public struct Product: Decodable {
    public let id: Int?
    public let name: String?
    public let image: String?
    public let category: Category?
    public let price: Int?
    public let brand: String?
    public let productNumber: Int?
    public let cartId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
        case productNumber = "siparisAdeti"
        case cartId = "sepetId"
    }
}

// MARK: - Category
public enum Category: String, Codable {
    case accessories = "Aksesuar"
    case cosmetics = "Kozmetik"
    case technology = "Teknoloji"
}
