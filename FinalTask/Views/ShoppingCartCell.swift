//
//  BasketItemCell.swift
//  FinalTask
//
//  Created by Tayfun Sener on 15.04.2024.
//

import UIKit

protocol BasketItemCellDelegate: AnyObject {
    func basketItemCell(_ cell: ShoppingCartCell, didUpdateProduct product: Product, newQuantity: Int)
}

class ShoppingCartCell: UITableViewCell {
    
    weak var delegate: BasketItemCellDelegate?
    
    let productImageView = UIImageView()
    let productNameLabel = UILabel()
    let attributeLabel = UILabel()
    let quantityLabel = UILabel()
    let decrementButton = UIButton()
    let incrementButton = UIButton()
    let priceLabel = UILabel()
    
    let productContainerView = UIView()
    let quantityContainerView = UIView()
    let deleteButton = UIButton()
    
    var product: Product? {
            didSet {
                updateUI()
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupCellUI()
            configureSubviews()
        }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func configureSubviews() {
        productNameLabel.font = .openSansRegular(size: 12)
        productNameLabel.numberOfLines = 0
        productNameLabel.lineBreakMode = .byWordWrapping
        attributeLabel.font = .openSansRegular(size: 12)
        priceLabel.font = .openSansBold(size: 14)
        priceLabel.textColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        quantityLabel.font = .openSansBold(size: 14)
        quantityLabel.backgroundColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
        quantityLabel.textColor = .white
        quantityLabel.textAlignment = .center
        decrementButton.setImage(UIImage(named: "minusLogo"), for: .normal)
        incrementButton.setImage(UIImage(named: "plusLogo"), for: .normal)
        deleteButton.setImage(UIImage(named: "trashLogo"), for: .normal)
        decrementButton.addTarget(self, action: #selector(decrementQuantity), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementQuantity), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        
    }

    private func setupCellUI() {
           let views = [productContainerView, quantityContainerView, productImageView, productNameLabel, attributeLabel, quantityLabel, decrementButton, incrementButton, priceLabel, deleteButton]
           views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
           productContainerView.layer.cornerRadius = 10
           productContainerView.clipsToBounds = false
           productImageView.contentMode = .scaleAspectFit
           productContainerView.addSubview(productImageView)
           productContainerView.addSubview(productNameLabel)
           productContainerView.addSubview(attributeLabel)
           productContainerView.addSubview(priceLabel)
           quantityContainerView.addSubview(decrementButton)
           quantityContainerView.addSubview(quantityLabel)
           quantityContainerView.addSubview(incrementButton)
           quantityContainerView.addSubview(deleteButton)

           contentView.addSubview(productContainerView)
           contentView.addSubview(quantityContainerView)

            NSLayoutConstraint.activate([
               productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
               productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
               productImageView.widthAnchor.constraint(equalToConstant: 74),
               productImageView.heightAnchor.constraint(equalToConstant: 74),
               productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
               productNameLabel.trailingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: 0),
               productNameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 4),
               productNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -30),
               attributeLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
               attributeLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor),
               attributeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 2),
               priceLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
               priceLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor),
               priceLabel.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 4),
               quantityContainerView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
               quantityContainerView.heightAnchor.constraint(equalToConstant: 32),
               quantityContainerView.widthAnchor.constraint(equalToConstant: 96),
               quantityContainerView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 197),
               quantityLabel.widthAnchor.constraint(equalToConstant: 32),
               quantityLabel.heightAnchor.constraint(equalToConstant: 32),
               quantityLabel.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor),
               quantityLabel.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
               decrementButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: 0),
               decrementButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
               decrementButton.widthAnchor.constraint(equalToConstant: 18),
               decrementButton.heightAnchor.constraint(equalToConstant: 18),
               incrementButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 0),
               incrementButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
               incrementButton.widthAnchor.constraint(equalToConstant: 18),
               incrementButton.heightAnchor.constraint(equalToConstant: 18),
               deleteButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: 0),
               deleteButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
               deleteButton.widthAnchor.constraint(equalToConstant: 18),
               deleteButton.heightAnchor.constraint(equalToConstant: 18)
                ])
        
        }
    
    private func updateUI() {
        guard let product = product else { return }
            productNameLabel.text = product.name
            quantityLabel.text = "\(product.quantity)"
            priceLabel.text = product.priceText
            attributeLabel.text = product.attribute ?? "Detay Yok"
            productImageView.accessibilityIdentifier = product.imageURL
            if product.quantity == 1 {
                decrementButton.isHidden = true
                deleteButton.isHidden = false
                
            } else {
                decrementButton.isHidden = false
                deleteButton.isHidden = true
            }
            ImageLoader.loadImage(for: productImageView, with: product.imageURL, placeholder: UIImage(named: "Image1"))
        }
    
    @objc private func deleteItem() {
        guard let product = product else { return }
        CartManager.shared.removeProduct(product)
        updateUI()
        NotificationCenter.default.post(name: NSNotification.Name("cartItemDeleted"), object: nil)
        
    }
    
    @objc private func decrementQuantity() {
            guard let product = product else { return }
            CartManager.shared.removeProduct(product)
            updateUI()
        }
        
        @objc private func incrementQuantity() {
            guard let product = product else { return }
            CartManager.shared.addProduct(product)
            updateUI()
        }
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
