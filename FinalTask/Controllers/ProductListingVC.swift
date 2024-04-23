//
//  ProductListing.swift
//  FinalTask
//
//  Created by Tayfun Sener on 9.04.2024.
//

import UIKit

private let reuseIdentifier = "Cell"

final class ProductListingVC: UICollectionViewController, ProductDetailViewControllerDelegate {
    
    var horizontalProducts: [Product] = []
    var verticalProducts: [Product] = []
    var currentImageUrl: String?
    var totalPrice: Double = 0.00 {
            didSet {updateCartButton()}
        }
    
    init() {
        super.init(collectionViewLayout: ProductListingVC.createLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCartButton()
        configureNavigationBar()
        loadHorizontalProducts()
        loadVerticalProducts()
        setupNotifications()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartButton()
        collectionView.reloadData()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(itemDeleted(_:)), name: .cartItemDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartCleared), name: .cartCleared, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartButton), name: .cartUpdated, object: nil)
       }
    
    func configureNavigationBar() {
            navigationItem.title = "Ürünler"
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            let customFont = UIFont.openSansBold(size: 14)
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: customFont as Any]
            navBarAppearance.backgroundColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    
    func didAddProductToCart() {
        updateCartButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func itemDeleted(_ notification: Notification) {
        if let productID = notification.userInfo?["productID"] as? String {
            
            var isUpdated = false
            if let index = horizontalProducts.firstIndex(where: { $0.id == productID }) {
                horizontalProducts[index].quantity = 0
                isUpdated = true
            } else if let index = verticalProducts.firstIndex(where: { $0.id == productID }) {
                verticalProducts[index].quantity = 0
                isUpdated = true
            }
            
            if isUpdated {
                let indexPaths = collectionView.indexPathsForVisibleItems.filter { indexPath in
                    let product = (indexPath.section == 0) ? horizontalProducts[indexPath.item] : verticalProducts[indexPath.item]
                    return product.id == productID
                }
                collectionView.reloadItems(at: indexPaths)
            }
        }
    }

    @objc private func updateCartButton() {
        if let containerView = navigationItem.rightBarButtonItem?.customView,
               let label = containerView.subviews.compactMap({ $0 as? UILabel }).first {
                label.text = String(format: "₺%.2f", CartManager.shared.totalPrice)
            }
    }
    
    @objc private func handleCartCleared() {
        for product in horizontalProducts {
            product.quantity = 0
        }
        for product in verticalProducts {
            product.quantity = 0
        }
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = indexPath.section == 0 ? horizontalProducts[indexPath.row] : verticalProducts[indexPath.row]
        let detailVC = ProductDetailVC()
        detailVC.product = product
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout {
            (sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0 / 3.0),
                    heightDimension: .estimated(153)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.trailing = 16
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .estimated(185)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 8)
                section.orthogonalScrollingBehavior = .continuous
                return section
            }

            if sectionNumber == 1 {

                let itemWidthFraction: CGFloat = 0.93 / 3.0
                let spacingBetweenItems: CGFloat = 8.0
                _ = spacingBetweenItems * 2

                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemWidthFraction),
                    heightDimension: .estimated(164.67)
                )

                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                    leading: nil,
                    top: nil,
                    trailing: NSCollectionLayoutSpacing.fixed(spacingBetweenItems),
                    bottom: NSCollectionLayoutSpacing.fixed(16)
                )

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200)
                )

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(spacingBetweenItems)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

                return section
            
                    } else {return nil}
        }
    }
    
    func loadHorizontalProducts() {
        guard let url = Bundle.main.url(forResource: "horizontalProducts", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not find horizontalProducts.json in the bundle.")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let productSections = try decoder.decode([ProductSection].self, from: data)
            if let firstSection = productSections.first {
                horizontalProducts = firstSection.products
                
            }
            collectionView.reloadData()
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func loadVerticalProducts() {
        guard let url = Bundle.main.url(forResource: "verticalProducts", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not find verticalProducts.json in the bundle.")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let productSections = try decoder.decode([ProductSection].self, from: data)
            if let firstSection = productSections.first {
                verticalProducts = firstSection.products
                
            }
            collectionView.reloadData()
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(ProductListingCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        
    }
    
    private func configureCartButton() {
        
        
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 8
            containerView.clipsToBounds = true
            let cartButton = UIButton(type: .custom)
            cartButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(cartButton)
            if let cartImage = UIImage(named: "logoImage") {
                cartButton.setImage(cartImage, for: .normal)
                cartButton.imageView?.contentMode = .scaleAspectFit
            }

            let priceLabel = UILabel()
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            priceLabel.text = "₺\(totalPrice)"
            priceLabel.textColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            priceLabel.font = UIFont(name: "OpenSans-Bold", size: 12)
            containerView.addSubview(priceLabel)

            if let imageView = cartButton.imageView {
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
                    imageView.widthAnchor.constraint(equalToConstant: 34),
                    imageView.heightAnchor.constraint(equalToConstant: 34),
                    priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                    priceLabel.leadingAnchor.constraint(equalTo: cartButton.imageView!.trailingAnchor, constant: 6),
                    priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                    cartButton.topAnchor.constraint(equalTo: containerView.topAnchor),
                    cartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    cartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
                ])
            }

            containerView.heightAnchor.constraint(equalToConstant: 34).isActive = true
            containerView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
            cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        let cartBarButtonItem = NavigationCartButton.createCartButton(target: self, action: #selector(navigateToCartVC))
            self.navigationItem.rightBarButtonItem = cartBarButtonItem
        }
    
    @objc func navigateToCartVC() {
        let cartVC = ShoppingCartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc func cartButtonTapped() {
        if CartManager.shared.items.count != 0 {
            let controller = ShoppingCartVC()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func loadImage(for cell: ProductListingCollectionViewCell, with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid or missing URL string for image.")
            cell.productImageView.image = UIImage(named: "Image1")
            return
        }
        
        cell.productImageView.image = UIImage(named: "defaultPlaceholder")
        cell.currentImageUrl = urlString

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    if cell.currentImageUrl == urlString {
                        cell.productImageView.image = UIImage(named: "defaultPlaceholder")
                    }
                }
                
                return
            }
            
            DispatchQueue.main.async {
                if cell.currentImageUrl == urlString {
                    cell.productImageView.image = image
                }
            }
        }.resume()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {return 2}

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
                return horizontalProducts.count
            } else if section == 1 {
                return verticalProducts.count
            }
            return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! ProductListingCollectionViewCell
                
            let product = (indexPath.section == 0) ? horizontalProducts[indexPath.item] : verticalProducts[indexPath.item]

            ImageLoader.loadImage(for: cell.productImageView, with: product.imageURL)

            cell.priceLabel.text = product.priceText
            cell.productNameLabel.text = product.name
            cell.attributeLabel.text = "Details"
            cell.configure(with: product)
            cell.delegate = self
            return cell
        
        }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProductListingCollectionViewCell {
            ImageLoader.cancelLoad(for: cell.productImageView)
        }
    }
}

extension ProductListingVC: CustomCollectionViewCellDelegate {
    func didChangeProductQuantity(_ cell: ProductListingCollectionViewCell, product: Product, increment: Bool) {
        if increment {
                    CartManager.shared.addProduct(product)
                } else {
                    CartManager.shared.removeProduct(product)
                }
                updateCartButton()
        if product.quantity == 0 {
            collectionView.reloadData()
        }
    }
    
    func didTapAddButton(on cell: ProductListingCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let product = indexPath.section == 0 ? horizontalProducts[indexPath.row] : verticalProducts[indexPath.row]
            CartManager.shared.addProduct(product)
            updateCartButton()
    }
    
    func didTapTrashButton(on cell: ProductListingCollectionViewCell) {
            guard let indexPath = collectionView.indexPath(for: cell) else {
                return
            }
            CartManager.shared.removeProduct(cell.product)
            collectionView.reloadItems(at: [indexPath])
        }
}






