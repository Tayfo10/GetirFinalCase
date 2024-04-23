//
//  Product.swift
//  FinalTask
//
//  Created by Tayfun Sener on 13.04.2024.
//

import Foundation

class Product: Codable {
    let id: String
    var imageURL: String?
    let price: Double
    let name: String
    let priceText: String
    var squareThumbnailURL: String?
    var quantity: Int = 0
    var attribute: String?

    enum CodingKeys: String, CodingKey {
        case id, price, name, priceText, imageURL, squareThumbnailURL, attribute
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        price = try container.decode(Double.self, forKey: .price)
        name = try container.decode(String.self, forKey: .name)
        priceText = try container.decode(String.self, forKey: .priceText)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        squareThumbnailURL = try container.decodeIfPresent(String.self, forKey: .squareThumbnailURL)
        attribute = try container.decodeIfPresent(String.self, forKey: .attribute)
        
        if imageURL == nil {
            imageURL = squareThumbnailURL
        }
    }
    
    init(id: String, imageURL: String?, price: Double, name: String, priceText: String, squareThumbnailURL: String?, quantity: Int, attribute: String?) {
        self.id = id
        self.imageURL = imageURL
        self.price = price
        self.name = name
        self.priceText = priceText
        self.squareThumbnailURL = squareThumbnailURL
        self.quantity = quantity
        self.attribute = attribute
    }
}


