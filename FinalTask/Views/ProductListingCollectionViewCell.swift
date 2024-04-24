//
//  CustomCollectionViewCell.swift
//  FinalTask
//
//  Created by Tayfun Sener on 10.04.2024.
//

import UIKit

protocol CustomCollectionViewCellDelegate: AnyObject {
    func didTapAddButton(on cell: ProductListingCollectionViewCell)
    func didChangeProductQuantity(_ cell: ProductListingCollectionViewCell, product: Product, increment: Bool)
}

class ProductListingCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CustomCollectionViewCellDelegate?
    
    var currentImageUrl: String?
    var quantityLabel: UILabel!
    var trashButton: UIButton!
    var product: Product!
    var heightConstraint: NSLayoutConstraint!
    
    var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        label.font = .openSansBold(size: 14)
        
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.00)
        label.font = .openSansRegular(size: 12)
        return label
    }()
    
    let attributeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.41, green: 0.45, blue: 0.53, alpha: 1.00)
        label.font = .openSansRegular(size: 12)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plusLogo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = nil
        button.backgroundColor = .clear
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "minusLogo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = nil
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 0.95, green: 0.94, blue: 0.98, alpha: 1.00).cgColor
        button.layer.cornerRadius = 2.0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(attributeLabel)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 92),
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productNameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            attributeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 2),
            attributeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
        ])
        
        addButton.tintColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        addButton.layer.masksToBounds = true
        addButton.layer.borderWidth = 1.0
        addButton.layer.borderColor = UIColor(red: 0.95, green: 0.94, blue: 0.98, alpha: 1.00).cgColor
        addButton.layer.cornerRadius = 8.0
        addButton.layer.zPosition = 1
        productImageView.layer.borderWidth = 1.0
        productImageView.layer.borderColor = UIColor(red: 0.95, green: 0.94, blue: 0.98, alpha: 1.00).cgColor
        productImageView.layer.cornerRadius = 16.0
        productImageView.layer.masksToBounds = true
        quantityLabel = UILabel()
        quantityLabel.textAlignment = .center
        quantityLabel.backgroundColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        quantityLabel.textColor = .white
        quantityLabel.font = .openSansBold(size: 12)
        trashButton = UIButton(type: .system)
        trashButton.setImage(UIImage(named: "trashLogo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        trashButton.tintColor = nil  
        trashButton.backgroundColor = .clear
        stackView.addArrangedSubview(addButton)
        stackView.addArrangedSubview(quantityLabel)
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(trashButton)
        stackView.bringSubviewToFront(addButton)
        
        contentView.addSubview(stackView)
        
        heightConstraint = stackView.heightAnchor.constraint(equalToConstant: 24)
        heightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            stackView.widthAnchor.constraint(equalToConstant: 24),
            
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButtonTapped() {
        
        delegate?.didTapAddButton(on: self)
        updateQuantityDisplay()
    }
    
    @objc func minusButtonTapped() {
        if product.quantity > 1 {
            delegate?.didChangeProductQuantity(self, product: product, increment: false)
            updateQuantityDisplay()
        }
    }
    
    @objc func trashButtonTapped() {
        if product.quantity > 0 {
            product.quantity = 0
            CartManager.shared.removeProduct(product)
            delegate?.didChangeProductQuantity(self, product: product, increment: false)
            updateQuantityDisplay()
        }
    }
    
    func configure(with product: Product) {
        self.product = product
        productNameLabel.text = product.name
        priceLabel.text = product.priceText
        attributeLabel.text = product.attribute ?? "Detay Yok"
        updateQuantityDisplay()
    }
    
    private func updateQuantityDisplay() {
        
        guard let product = product else { return }
        quantityLabel.text = "\(product.quantity)"
        quantityLabel.isHidden = product.quantity == 0
        trashButton.isHidden = product.quantity != 1
        minusButton.isHidden = product.quantity < 2
        addButton.isHidden = false
        addButton.isEnabled = true
        if product.quantity > 0 {
            addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            addButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        let newHeight: CGFloat = product.quantity > 0 ? 64.0 : 24.0
        if heightConstraint.constant != newHeight {
            heightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}
