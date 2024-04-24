//
//  CartManager.swift
//  FinalTask
//
//  Created by Tayfun Sener on 15.04.2024.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private(set) var items: [Product] = []
    
    var totalPrice: Double {
        return items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    func addProduct(_ product: Product) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index].quantity += 1
            notifyCartUpdated()
        } else {
            let newProduct = product
            newProduct.quantity = 1
            items.append(newProduct)
            notifyCartUpdated()
        }
    }
    
    private func notifyCartUpdated() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil, userInfo: ["totalPrice": totalPrice])
    }
    
    func removeProduct(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.id == product.id }) else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
            
            NotificationCenter.default.post(name: .cartItemDeleted, object: nil, userInfo: ["productID": product.id])
        }
        
        notifyCartUpdated()
    }
    
    func clearCart() {
        items.removeAll()
    }
    func getCartItems() -> [Product] {
        return items
    }
    
    func updateProductQuantity(_ productId: String, newQuantity: Int) {
        if let index = items.firstIndex(where: { $0.id == productId }) {
            items[index].quantity = newQuantity
            notifyCartUpdated()
        }
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
    static let cartCleared = Notification.Name("cartCleared")
    static let cartItemDeleted = Notification.Name("cartItemDeleted")
    static let productUpdated = Notification.Name("productUpdated")
}



