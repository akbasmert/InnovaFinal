//
//  HomeViewController.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import UIKit

class HomeViewController: UIViewController, LoadingShowable {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var isOnSplahView: Bool = true
    private var isFilteredList: Bool = false
    private var productID: Int?
    private var productIndex: Int = 0
    
    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel.shared
        homeViewModel.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleImageTapped(notification:)),
            name: Notification.Name("ImageTapped"),
            object: nil
        )
        
        setAccessiblityIdentifiers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isOnSplahView {
            performSegue(withIdentifier: "toSplashScreen", sender: nil)
            isOnSplahView = false
        }
    }
    
    @objc private func handleImageTapped(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let index = userInfo["index"] as? Int else { return }
        
        productID = homeViewModel.getProductDetailID(index: index)
        productIndex = index
        
        performSegue(withIdentifier: "homeToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homeToDetail" {
            
            let destinationDetailVC = segue.destination as! DetailViewController
            
            destinationDetailVC.productDetailID = productID
            
            destinationDetailVC.productName = homeViewModel.getProductName(
                index: productIndex,
                isFiltered: isFilteredList
            )
            
            destinationDetailVC.productImage = homeViewModel.getProductImage(
                index: productIndex,
                isFiltered: isFilteredList
            )
            
            destinationDetailVC.productPrice = homeViewModel.getProductPrice(
                index: productIndex,
                isFiltered: isFilteredList
            )
            
            destinationDetailVC.productBrand = homeViewModel.getProductBrand(
                index: productIndex,
                isFiltered: isFilteredList
            )
            
            destinationDetailVC.productCategory = homeViewModel.getProductCategory(
                index: productIndex,
                isFiltered: isFilteredList
            )
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isFilteredList ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFilteredList {
            
            if homeViewModel.filteredNumberOfItems == 0 {
                
                return 1
                
            } else {
                
                return homeViewModel.filteredNumberOfItems
                
            }
        } else {
            
            if section == 0 {
                
                return 1
                
            } else {
                
                return homeViewModel.numberOfItems - 3
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isFilteredList {
            
            if homeViewModel.filteredNumberOfItems == 0 {
                
                guard let noDataCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NoResultCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? NoResultCollectionViewCell else {
                    fatalError("no cell")
                }
                
                return  noDataCell
                
            } else {
                
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? HomeCollectionViewCell else {
                    fatalError("no cell")
                }
                
                if let product = self.homeViewModel.filteredProduct(indexPath.row) {
                    homeCell.configure(product: product)
                }
                
                return homeCell
            }
            
        } else {
            
            if indexPath.section == 0 {
                
                guard let pageViewCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PageCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? PageCollectionViewCell else {
                    fatalError("no cell")
                }
                
                let pageViewProduct = homeViewModel.product
                
                pageViewCell.configure(product: pageViewProduct)
                
                return  pageViewCell
                
            } else {
                
                guard let homeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? HomeCollectionViewCell else {
                    fatalError("no cell")
                }
                
                if let product = self.homeViewModel.product(indexPath.row) {
                    homeCell.configure(product: product)
                }
                
                return homeCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFilteredList {
            
            if homeViewModel.filteredNumberOfItems != 0 {
                
                productIndex = indexPath.row
                productID = homeViewModel.getFilteredProductDetailID(
                    index: indexPath.row
                )
                
                performSegue(withIdentifier: "homeToDetail", sender: nil)
            }
            
        } else {
            
            if indexPath.section == 0 {
                
            } else {
                
                productIndex = indexPath.row + 3
                
                productID = homeViewModel.getProductDetailID(
                    index: indexPath.row + 3
                )
                
                performSegue(withIdentifier: "homeToDetail", sender: nil)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let width = self.collectionView.bounds.size.width
        let height = self.collectionView.bounds.size.height
        
        if isFilteredList {
            
            if homeViewModel.filteredNumberOfItems == 0 {
                
                return CGSize(
                    width: width,
                    height: height
                )
                
            } else {
                
                return CGSize(
                    width: width,
                    height: 200
                )
            }
            
        } else {
            
            if indexPath.section == 0 {
                
                return CGSize(
                    width: width,
                    height: width * 0.7
                )
            }
            
            return CGSize(
                width: width / 2 - 5,
                height: 200
            )
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String
    ) {
        
        searchBar.showsCancelButton = true
        
        if searchText.count >= 3 {
            
            isFilteredList = true
            homeViewModel.filteredProduct(key: searchText)
            collectionView.reloadData()
            
        } else {
            
            isFilteredList = false
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        isFilteredList = false
        searchBar.text = ""
        collectionView.reloadData()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Lütfen oyun adı giriniz."
    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        
        collectionView.register(UINib(nibName: "PageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PageCollectionViewCell.reuseIdentifier)
        
        collectionView.register(UINib(nibName: "NoResultCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: NoResultCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController {
    func setAccessiblityIdentifiers() {
        collectionView.accessibilityIdentifier = "collectionView"
        searchBar.accessibilityIdentifier = "searchBar"
    }
}
