//
//  CartViewController.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 11.10.2024.
//

import UIKit
import Lottie

class CartViewController: UIViewController, LoadingShowable {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    private  var animationView: LottieAnimationView!

    var cartViewModel: CartViewModelProtocol! {
        didSet {
            cartViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cartViewModel = CartViewModel.shared
        cartViewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cartViewModel.fetchProducts()
    }
    
    @IBAction func cartTappedButton(_ sender: Any) {
        
        if cartViewModel.numberOfItems == 0 {
            self.tabBarController?.selectedIndex = 0
        } else {
            setupAnimationView()
            
            DispatchQueue.main.async {
                self.cartViewModel.deleteAllProducts()
            }
        }
    }
    
    func setupAnimationView() {
    
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        
        animationView = .init(name: "Animation - 1729157942011")
        animationView.frame = view.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        
        animationView.play { [weak self] (finished) in
            if finished {
                self?.tabBarController?.selectedIndex = 0
                self?.animationView.removeFromSuperview()
                blurEffectView.removeFromSuperview()
            }
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        if cartViewModel.numberOfItems == 0 {
            return 1
        } else {
            return cartViewModel.numberOfItems
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if cartViewModel.numberOfItems == 0 {
             let noDataCell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.reuseIdentifier) as! NoDataTableViewCell
            noDataCell.selectionStyle = .none
           
            return noDataCell
          
        } else {
            let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartTableCell") as! CartTableViewCell
                cell.selectionStyle = .none
            
                let name = self.cartViewModel.getName(index: indexPath.row) ?? ""

                let brand = self.cartViewModel.getBrandName(for: name) ?? ""

                let price = self.cartViewModel.getPrice(for: name) ?? 0

                let number = self.cartViewModel.getTotalProductNumber(for: name)

                let image = self.cartViewModel.getImage(for: name) ?? ""

                cell.configure(
                    name: name,
                    brand: brand,
                    price: price,
                    number: number,
                    image: image
                )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"
        ){
            contextualAction,
            view,
            bool in
                
                let alert = UIAlertController(
                    title: "Silme İşlemi",
                    message: "Ürün silinsin mi?",
                    preferredStyle: .alert
                )
                
                let iptalAction = UIAlertAction(
                    title: "İptal",
                    style: .cancel
                )
                alert.addAction(iptalAction)
                
                let name = self.cartViewModel.getName(index: indexPath.row) ?? ""
                
                let evetAction = UIAlertAction(
                    title: "Evet",
                    style: .destructive
                ){ action in
                    self.cartViewModel.deleteProducts(name:name)
                }
                alert.addAction(evetAction)
                
                self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if cartViewModel.numberOfItems != 0 {
            return 100
        } else {
            let height = tableView.bounds.size.height
            return height
        }
    }
}

extension CartViewController: CartViewModelDelegate {
    
    func setupTableView() {
        cartTableView.register(
            UINib(nibName: "NoDataTableViewCell", bundle: nil),
                           forCellReuseIdentifier: NoDataTableViewCell.reuseIdentifier)
        cartTableView.dataSource = self
        cartTableView.delegate = self
    }
    
    func setPriceLabel() {
        priceLabel.text = "₺\(cartViewModel.getTotalProductsNumber())"
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        cartTableView.reloadData()
    }
}
