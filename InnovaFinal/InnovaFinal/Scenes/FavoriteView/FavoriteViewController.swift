//
//  FavoriteViewController.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import UIKit

class FavoriteViewController: UIViewController, LoadingShowable {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var index: Int?
    
    var favoriteViewModel: FavoriteViewModelProtocol! {
        didSet {
            favoriteViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteViewModel = FavoriteViewModel.shared
        favoriteViewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteViewModel.saveFilteredProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToDetail" {
            
            if let product = self.favoriteViewModel.favoriteProduct(index ?? 0) {
                let destinationDetailVC = segue.destination as! DetailViewController
                destinationDetailVC.productDetailID = Int(product.id)
                destinationDetailVC.productName = product.productName
                destinationDetailVC.productImage = product.productImage
                destinationDetailVC.productPrice = Int(product.productPrice)
                destinationDetailVC.productBrand = product.productBrand
                destinationDetailVC.productCategory = product.productCategory
            }
            
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteViewModel.numberOfItems == 0 {
            return 1
        } else {
            return favoriteViewModel.numberOfItems
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if favoriteViewModel.numberOfItems == 0 {
            
            let noDataCell = tableView.dequeueReusableCell(withIdentifier: FavoriNoDataTableViewCell.reuseIdentifier) as! FavoriNoDataTableViewCell
            noDataCell.selectionStyle = .none
            
            return noDataCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier, for: indexPath) as! FavoriteTableViewCell
            cell.selectionStyle = .none
            
            if let product = self.favoriteViewModel.favoriteProduct(indexPath.row) {
                cell.configure(product: product)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if favoriteViewModel.numberOfItems != 0 {
            self.index = indexPath.row
            performSegue(withIdentifier: "favoriteToDetail", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if favoriteViewModel.numberOfItems != 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Ürünü Sil", message: "Bu ürünü silmek istediğinizden emin misiniz?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                
                if let product = self.favoriteViewModel.favoriteProduct(indexPath.row) {
                    
                    if self.favoriteViewModel.numberOfItems != 0 {
                        
                        self.favoriteViewModel.checkProductData(
                            id: Int(product.id),
                            name: product.productName ?? "",
                            price: Int((product.productPrice )) ,
                            image: product.productImage ?? "",
                            brand: product.productBrand ?? "",
                            category: product.productCategory ?? "",
                            productNumber: 0
                        )
                        
                        DispatchQueue.main.async {
                            self.favoriteViewModel.saveFilteredProducts()
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if favoriteViewModel.numberOfItems != 0 {
            return 90
        } else {
            let height = tableView.bounds.size.height
            return height
        }
    }
}

extension FavoriteViewController: FavoriteViewModelDelegate {
    
    func setupTableView() {
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "FavoriNoDataTableViewCell", bundle: nil),
                           forCellReuseIdentifier: FavoriNoDataTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
