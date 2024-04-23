//
//  ProductDetailViewController.swift
//  FinalTask
//
//  Created by Tayfun Sener on 14.04.2024.
//

import UIKit

protocol ProductDetailViewControllerDelegate: AnyObject {
    func didAddProductToCart()
}

class ProductDetailVC: UIViewController {
    
    private var priceLabel: UILabel?
    
    var product: Product? {
            didSet {
                configureViewWithProduct()
                updateQuantityDisplay()
            }
        }
    weak var delegate: ProductDetailViewControllerDelegate?

    private let closeButton = UIButton()
    private let productImageView = UIImageView()
    private let productNameLabel = UILabel()
    private let productPriceLabel = UILabel()
    private let productAttributeLabel = UILabel()
    private let addToCartButton = UIButton()
    private let quantityStackView = UIStackView()
    private let trashButton = UIButton()
    private let quantityLabel = UILabel()
    private let plusButton = UIButton()
    private let minusButton = UIButton()
    
    let imageSize = CGSize(width: 24, height: 24)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartUpdate), name: .cartUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartCleared), name: .cartCleared, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartItemDeleted), name: .cartItemDeleted, object: nil)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productNameLabel.sizeToFit()
    }
    
    @objc private func handleCartItemDeleted() {
        if product?.quantity == 1 {
            product?.quantity = 0
            }
        if product?.quantity == 1 {
            product?.quantity = 0
            }
        updateCartDisplay()
        updateQuantityDisplay()
        }
    
    @objc func handleCartUpdate(notification: Notification) {
        updateQuantityDisplay()
        updateCartDisplay()
    }
    
    @objc private func handleCartCleared() {
        product?.quantity = 0
        updateQuantityDisplay()
        updateCartDisplay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavigationBar() {
        let crossImage = UIImage(systemName: "xmark")
        
        let closeButton = UIBarButtonItem(image: crossImage, style: .plain, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = .white
        navigationItem.title = "Ürün Detayı"
        navigationItem.leftBarButtonItem = closeButton
        
        let cartButton = NavigationCartButton.createCartButton(target: self, action: #selector(cartButtonTapped))
        navigationItem.rightBarButtonItem = cartButton
        updateCartDisplay()
    }
    
    @objc private func closeButtonTapped() {
        if isBeingPresented || presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else if navigationController?.isBeingPresented == true || navigationController?.presentingViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func cartButtonTapped() {
        let controller = ShoppingCartVC()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func configureButton(button: UIButton, imageName: String, imageSize: CGSize) {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        button.backgroundColor = .clear
        button.tintColor = nil
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
    }
    
    private func setupViews() {
            view.backgroundColor = .white
        
            closeButton.setTitle("X", for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            view.addSubview(closeButton)
            
            productImageView.contentMode = .scaleAspectFit
            view.addSubview(productImageView)
            
            productNameLabel.font = .openSansSemiBold(size: 16)
            productNameLabel.numberOfLines = 0
            
            view.addSubview(productNameLabel)
            
            productPriceLabel.font = .openSansBold(size: 20)
            productPriceLabel.textColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            view.addSubview(productPriceLabel)
            
            productAttributeLabel.font = .openSansSemiBold(size: 12)
            productAttributeLabel.textColor = UIColor(red: 0.41, green: 0.45, blue: 0.53, alpha: 1.00)
            view.addSubview(productAttributeLabel)
            
            addToCartButton.backgroundColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            addToCartButton.setTitle("Sepete Ekle", for: .normal)
            addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
            addToCartButton.titleLabel?.font = .openSansBold(size: 14)
            addToCartButton.layer.cornerRadius = 8
            view.addSubview(addToCartButton)
            
            configureButton(button: trashButton, imageName: "trashLogo", imageSize: imageSize)
            trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
            
            quantityLabel.textAlignment = .center
            quantityLabel.textColor = .white
            quantityLabel.font = .openSansBold(size: 16)
            quantityLabel.backgroundColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            
       
            configureButton(button: plusButton, imageName: "plusLogo", imageSize: imageSize)
            plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            configureButton(button: minusButton, imageName: "minusLogo", imageSize: imageSize)
            minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
            quantityStackView.addArrangedSubview(minusButton)
            quantityStackView.addArrangedSubview(trashButton)
            quantityStackView.addArrangedSubview(quantityLabel)
            quantityStackView.addArrangedSubview(plusButton)
            quantityStackView.axis = .horizontal
            quantityStackView.distribution = .fillEqually
            quantityStackView.spacing = 0
            view.addSubview(quantityStackView)
            quantityStackView.translatesAutoresizingMaskIntoConstraints = false
            setupConstraints()
        }
    
    private func setupConstraints() {
    
            [closeButton, productImageView, productNameLabel,
             productPriceLabel, productAttributeLabel, addToCartButton,
             quantityStackView].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                closeButton.widthAnchor.constraint(equalToConstant: 24),
                closeButton.heightAnchor.constraint(equalToConstant: 24),
                productImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
                productImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                productImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                productImageView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40),
                productNameLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8),
                productNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 60),
                productNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                productPriceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
                productPriceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                productAttributeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
                productAttributeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                addToCartButton.heightAnchor.constraint(equalToConstant: 50),
                quantityStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                quantityStackView.widthAnchor.constraint(equalToConstant: 146),
                        quantityStackView.heightAnchor.constraint(equalToConstant: 48),
                quantityStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                
            ])
        }
    
        private func configureViewWithProduct() {
            guard let product = product else { return }
                productNameLabel.text = product.name
                productNameLabel.textAlignment = .center
                productPriceLabel.text = "₺\(product.price)"
                productAttributeLabel.text = product.attribute ?? "Detay Yok"
                loadImage(with: product.imageURL)
            }
        
        private func loadImage(with urlString: String?) {
            guard let urlString = urlString, let _ = URL(string: urlString) else {
                print("Invalid or missing URL string for image.")
                productImageView.image = UIImage(named: "Image1")
                return
            }
            
            ImageLoader.loadImage(for: productImageView, with: urlString)
        }
    
        @objc private func addToCartButtonTapped() {
            product?.quantity += 1
            delegate?.didAddProductToCart()
            CartManager.shared.addProduct(product!)
            updateCartDisplay()
            updateQuantityDisplay()
        }
        
        @objc private func trashButtonTapped() {
            guard let product = product else { return }
                product.quantity = 0
                CartManager.shared.removeProduct(product)
                updateQuantityDisplay()
                updateCartDisplay()
        }
        
        @objc private func plusButtonTapped() {
            guard let product = product else { return }
                CartManager.shared.addProduct(product)
                updateQuantityDisplay()
                updateCartDisplay()
        }
    
        @objc private func minusButtonTapped() {
            guard let product = product, product.quantity > 1 else { return }
            CartManager.shared.removeProduct(product) 
            updateQuantityDisplay()
            updateCartDisplay()
        }
    
    private func updateQuantityDisplay() {
        guard let product = product else { return }
        quantityLabel.text = "\(product.quantity)"
        trashButton.isHidden = product.quantity != 1
        minusButton.isHidden = product.quantity <= 1
        quantityStackView.isHidden = product.quantity == 0
        addToCartButton.isHidden = product.quantity != 0
    }
    private func updateCartDisplay() {
        NavigationCartButton.updatePrice(newPrice: CartManager.shared.totalPrice)
        if CartManager.shared.items.isEmpty {
                navigationItem.rightBarButtonItem = nil
            } else {
                if navigationItem.rightBarButtonItem == nil {
                    let cartButton = NavigationCartButton.createCartButton(target: self, action: #selector(cartButtonTapped))
                    navigationItem.rightBarButtonItem = cartButton
                }
            }
    }
}
