//
//  DetailViewController.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import UIKit
import Lottie

class DetailViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var upperButton: UIButton!
    
    var productDetailID: Int?
    var productImage: String?
    var productName: String?
    var productPrice: Int?
    var productBrand: String?
    var productCategory: String?
    private var isFavorite: Bool = false
    private var numberOfProduct: Int = 1
    private  var animationView: LottieAnimationView!
    
    var detailViewModel: DetailViewModelProtocol! {
        didSet {
            detailViewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailViewModel = DetailViewModel.shared
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: getFavoriteImage(),
            style: .plain, target: self,
            action: #selector(favoriteButtonTapped)
        )
        
        detailViewModel.viewDidLoad()
        setAccessiblityIdentifiers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRightBarButtonItemImage(
            isFavorite: detailViewModel.isSavedProductId(productId: productDetailID ?? 1)
        )
    }
    
    @IBAction func downButton(_ sender: Any) {
        if numberOfProduct > 1 {
            numberOfProduct -= 1
        }
        numberLabel.text = String(numberOfProduct)
        setTotalPriceOfProducts()
    }
    
    @IBAction func upperButton(_ sender: Any) {
        numberOfProduct += 1
        numberLabel.text = String(numberOfProduct)
        setTotalPriceOfProducts()
    }
    
    @IBAction func addProductButton(_ sender: Any) {
        detailViewModel.saveProduct(
            name: productName ?? "",
            price: (productPrice ?? 0),
            image: productImage ?? "",
            brand: productBrand ?? "",
            category: productCategory ?? "",
            productNumber: numberOfProduct
        )
        setupAnimationView()
    }
    
    @objc func favoriteButtonTapped() {
         isFavorite.toggle()
         navigationItem.rightBarButtonItem?.image = getFavoriteImage()
        
        detailViewModel.checkProductData(
            id: productDetailID ?? 0,
            name: productName ?? "",
            price: (productPrice ?? 0),
            image: productImage ?? "",
            brand: productBrand ?? "",
            category: productCategory ?? "",
            productNumber: numberOfProduct
        )
    }
     
     func getFavoriteImage() -> UIImage? {
         let heartImageName = isFavorite ? "heart.fill" : "heart"
         return UIImage(systemName: heartImageName)
     }

   func setRightBarButtonItemImage(isFavorite: Bool) {
       let imageName = isFavorite ? "heart.fill" : "heart"
       self.isFavorite = isFavorite ? true : false
       let image = UIImage(systemName: imageName)
       navigationItem.rightBarButtonItem?.image = image
   }
    
    func setupAnimationView() {

        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        
        animationView = .init(name: "Animation - 1729156642213")
        animationView.frame = view.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        
        animationView.play { [weak self] (finished) in
            if finished {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.animationView.removeFromSuperview()
                blurEffectView.removeFromSuperview()
            }
        }
    }
}

extension DetailViewController: DetailViewModelDelegate {
    
    func setBrandOfProducts() {
        brandLabel.text = productBrand
    }
    
    func setNameOfProducts() {
        nameLabel.text = productName
    }
    
    func setTotalPriceOfProducts() {
         totalPrice.text = "₺" + String(numberOfProduct * (productPrice ?? 0))
    }
    
    func setPriceOfProducts() {
        priceLabel.text = "₺" + String(productPrice ?? 0)
    }
    
    func setNumberOfProducts() {
        numberLabel.text = String(numberOfProduct)
    }
    
    func setImage() {
        productImageView.image = detailViewModel.getImage(imageName: productImage ?? "")
    }
}

extension DetailViewController {
    
    func setAccessiblityIdentifiers() {
        productImageView.accessibilityIdentifier = "productImageView"
        brandLabel.accessibilityIdentifier = "brandLabel"
        nameLabel.accessibilityIdentifier = "nameLabel"
        numberLabel.accessibilityIdentifier = "numberLabel"
        totalPrice.accessibilityIdentifier = "totalPrice"
        priceLabel.accessibilityIdentifier = "priceLabel"
        addProductButton.accessibilityIdentifier = "addProductButton"
        upperButton.accessibilityIdentifier = "upperButton"
    }
}
