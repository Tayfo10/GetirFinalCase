//
//  BasketViewController.swift
//  FinalTask
//
//  Created by Tayfun Sener on 15.04.2024.
//

import UIKit

class ShoppingCartVC: UIViewController, BasketItemCellDelegate {

    let navigationBarView = UIView()
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let trashButton = UIButton()
    
    var tableView: UITableView!
    
    var basketItems: [Product] {
            return CartManager.shared.getCartItems()
        }
    
    let bottomView = UIView()
    let checkoutButton = UIButton()
    let totalPriceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupUI()
        setupNotifications()
        updateTotalPrice()
    }
    
    @objc private func cartUpdated(notification: Notification) {
        tableView.reloadData()
        if basketItems.count == 0 {
            totalPriceLabel.text = "₺0.00"
        }
        updateTotalPrice()
        tableView.reloadData()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
        
        }
    private func updateTotalPrice() {
            let totalPrice = CartManager.shared.totalPrice
            totalPriceLabel.text = "₺\(String(format: "%.2f", totalPrice))"
        }
    
    private func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    @objc private func checkoutTapped() {
        if CartManager.shared.items.count != 0{
            
            let alertController = UIAlertController(title: "Ödeme", message: "Bu ürünleri satın almak istediğinizden emin misiniz?", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Onayla", style: .default) { _ in
                self.completePurchase()
            }
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else {
            showAlertWith(title: "Sepet Boş", message: "Ürün ekledikten sonra tekrar deneyiniz.")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func completePurchase() {
        showPurchaseSuccessAlert()
        NotificationCenter.default.post(name: .cartCleared, object: nil)
        CartManager.shared.clearCart()
        totalPriceLabel.text = "₺0.00"
        tableView.reloadData()
    }
    
    private func showPurchaseSuccessAlert() {
        let totalCartPrice = CartManager.shared.totalPrice
            let formattedPrice = String(format: "%.2f", totalCartPrice)
            let message = "Ürünleri satın alma işlemi başarılı. Toplam sepet ödemeniz: \(formattedPrice) TL"

        let successAlert = UIAlertController(title: "Başarılı", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
                guard let navigationController = self?.navigationController else { return }
                if let productListingVC = navigationController.viewControllers.first(where: { $0 is ProductListingVC }) {
                    navigationController.popToViewController(productListingVC, animated: true)
                } else {
                    navigationController.popToRootViewController(animated: true)
                }
            }
            successAlert.addAction(okAction)
            present(successAlert, animated: true)
    }
    
    private func setupTableView() {
            tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(ShoppingCartCell.self, forCellReuseIdentifier: "BasketItemCell")
            tableView.frame = view.bounds
            view.addSubview(tableView)
            tableView.reloadData()
        }
    
    private func setupNavigationBar() {
        
        guard let openSansBold = UIFont(name: "OpenSans-Bold", size:14) else {return}
        UINavigationBar.appearance().titleTextAttributes =  [NSAttributedString.Key.font : openSansBold]
            navigationItem.title = "Sepetim"
            let closeImage = UIImage(systemName: "xmark")
            let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeButtonTapped))
            navigationItem.leftBarButtonItem = closeButton
            let trashImage = UIImage(systemName: "trash")
            let trashButton = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(trashButtonTapped))
            navigationItem.rightBarButtonItem = trashButton
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barTintColor = .purple
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    
    func setupUI() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
            ])
        
            bottomView.backgroundColor = .white
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            checkoutButton.setTitle("Siparişi Tamamla", for: .normal)
            checkoutButton.backgroundColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            checkoutButton.setTitleColor(.white, for: .normal)
            checkoutButton.layer.cornerRadius = 8
            checkoutButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner ]
            checkoutButton.layer.borderColor = UIColor(red: 0.41, green: 0.45, blue: 0.53, alpha: 1.00).cgColor
            checkoutButton.layer.borderWidth = 0.2
            checkoutButton.clipsToBounds = true
            checkoutButton.translatesAutoresizingMaskIntoConstraints = false
            checkoutButton.titleLabel?.textAlignment = .center
            checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        
            totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 18)
            totalPriceLabel.textColor = UIColor(red: 0.36, green: 0.24, blue: 0.74, alpha: 1.00)
            totalPriceLabel.layer.borderColor = UIColor(red: 0.41, green: 0.45, blue: 0.53, alpha: 1.00).cgColor
            totalPriceLabel.layer.borderWidth = 0.8
            totalPriceLabel.layer.cornerRadius = 8
            totalPriceLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner ]
            totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            totalPriceLabel.textAlignment = .center
            bottomView.addSubview(checkoutButton)
            bottomView.addSubview(totalPriceLabel)
            
        NSLayoutConstraint.activate([
                bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                bottomView.heightAnchor.constraint(equalToConstant: 100),
                checkoutButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
                checkoutButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
                checkoutButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
                totalPriceLabel.leadingAnchor.constraint(equalTo: checkoutButton.trailingAnchor, constant: 0),
                totalPriceLabel.centerYAnchor.constraint(equalTo: checkoutButton.centerYAnchor),
                totalPriceLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
                totalPriceLabel.heightAnchor.constraint(equalTo: checkoutButton.heightAnchor),
            ])
        
        let checkoutButtonWidthConstraint = checkoutButton.widthAnchor.constraint(equalToConstant: 260)
            checkoutButtonWidthConstraint.isActive = true
        }
    
        @objc private func closeButtonTapped() {
            if isBeingPresented || presentingViewController != nil {
                dismiss(animated: true, completion: nil)
            } else if navigationController?.isBeingPresented == true || navigationController?.presentingViewController != nil {
                navigationController?.dismiss(animated: true, completion: nil)
            } else {navigationController?.popViewController(animated: true)}
            }
        
        @objc private func trashButtonTapped() {
            CartManager.shared.clearCart()
                    tableView.reloadData()
            NotificationCenter.default.post(name: .cartCleared, object: nil)
            totalPriceLabel.text = "₺0.00"
        }
    func basketItemCell(_ cell: ShoppingCartCell, didUpdateProduct product: Product, newQuantity: Int) {
        }
}

// MARK: - TableView Delegate & DataSource
extension ShoppingCartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasketItemCell", for: indexPath) as? ShoppingCartCell else {
                fatalError("Dequeued cell is not an instance of BasketItemCell.")
            }
            cell.product = basketItems[indexPath.row]
            cell.delegate = self
            return cell
    }
}


