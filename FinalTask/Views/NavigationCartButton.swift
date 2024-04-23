//
//  NavigationCartButton.swift
//  FinalTask
//
//  Created by Tayfun Sener on 15.04.2024.
//

import UIKit

class NavigationCartButton {
    
    private static var priceLabel: UILabel?

    static func createCartButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        let cartButton = UIButton(type: .custom)
        containerView.addSubview(cartButton)
        if let cartImage = UIImage(named: "logoImage") {
            cartButton.setImage(cartImage, for: .normal)
            cartButton.imageView?.contentMode = .scaleAspectFit
            cartButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        }
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        priceLabel.font = UIFont(name: "OpenSans-Bold", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        containerView.addSubview(priceLabel)
        self.priceLabel = priceLabel
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 34),
            cartButton.heightAnchor.constraint(equalToConstant: 34),

            priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 6),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])

        containerView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        priceLabel.isUserInteractionEnabled = true

        let labelTapGesture = UITapGestureRecognizer(target: target, action: action)
                priceLabel.addGestureRecognizer(labelTapGesture)
        cartButton.addTarget(target, action: action, for: .touchUpInside)

        let cartBarButtonItem = UIBarButtonItem(customView: containerView)
        updatePrice(newPrice: CartManager.shared.totalPrice)  
        return cartBarButtonItem
    }

    static func updatePrice(newPrice: Double) {
        DispatchQueue.main.async {
            priceLabel?.text = String(format: "₺%.2f", newPrice)
        }
    }
}
