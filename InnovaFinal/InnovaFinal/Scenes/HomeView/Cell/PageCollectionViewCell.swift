//
//  PageCollectionViewCell.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 9.10.2024.
//
import UIKit
import SDWebImage
import InnovaFinalAPI

class PageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    static let reuseIdentifier = String(describing: PageCollectionViewCell.self)
    
    private var currentPage = 0
    var images: [String] = []
    var names: [String] = []
    var brands: [String] = []
    var prices: [Int] = []
    var categories: [String] = []
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pageController.addTarget(self, action: #selector(pageChange(_:)), for: .valueChanged)
        scrollView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scrollView.addGestureRecognizer(tapGesture)
        
        startAutoScroll()
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(scrollToNextImage),
            userInfo: nil, repeats: true
        )
    }

    @objc private func scrollToNextImage() {
        
        currentPage += 1
        if currentPage >= images.count {
            currentPage = 0
        }
        
        let offsetX = CGFloat(currentPage) * scrollView.frame.size.width
        
        scrollView.setContentOffset(
            CGPoint(x: offsetX, y: 0),
            animated: true
        )
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
          let location = gestureRecognizer.location(in: scrollView)
          let tappedPageIndex = Int(location.x / scrollView.bounds.width)
        
          let userInfo: [AnyHashable: Any] = [ "index": tappedPageIndex ]
        
          NotificationCenter.default.post(name: Notification.Name("ImageTapped"), object: nil, userInfo: userInfo)
      }

    @objc private func pageChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * scrollView.frame.size.width, y: 0), animated: true)
    }

    func configure(product: [Product]) {
        
        for i in 0..<3 {
            if i < product.count {
                let product = product[i]
                
                if let backgroundImage = product.image {
                    images.append(backgroundImage)
                }
                
                if let name = product.name {
                    names.append(name)
                }
                
                if let brand = product.brand {
                    brands.append(brand)
                }
                
                if let price = product.price {
                    prices.append(price)
                }
                
                if let category = product.category {
                    categories.append(category.rawValue)
                }
                
                if i == 2 {
                    changeScrollView()
                }
            }
        }
    }
    
    private func changeScrollView() {
        
        scrollView.contentSize = CGSize(
            width: scrollView.bounds.width * CGFloat(images.count),
            height: scrollView.bounds.height
        )
        scrollView.isPagingEnabled = true

        for i in 0..<images.count {
            
            let page = UIView(
                frame: CGRect(x: CGFloat(i) * scrollView.bounds.width,
                              y: 0, width: scrollView.bounds.width,
                              height: scrollView.bounds.height)
            )
            scrollView.addSubview(page)
            
            let image = UIImageView(
                frame: CGRect(x: CGFloat(i) * scrollView.bounds.width,
                              y: 0, width: scrollView.bounds.width,
                              height: scrollView.bounds.height - 10)
            )
            
            if let imageURL = URL(string:"http://kasimadalan.pe.hu/urunler/resimler/\(images[i])" ) {
                image.sd_setImage(with: imageURL)
            }
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius = 8.0
            image.clipsToBounds = true
            scrollView.addSubview(image)
            
            let infoStackView = UIStackView(
                frame: CGRect(x: CGFloat(i) * scrollView.bounds.width + 10,
                              y: scrollView.bounds.height - 20,
                              width: scrollView.bounds.width - 20, height: 15)
            )
            
            infoStackView.axis = .vertical
            infoStackView.spacing = 0
            scrollView.addSubview(infoStackView)
            
            let nameBrandStackView = UIStackView()
            nameBrandStackView.axis = .horizontal
            nameBrandStackView.distribution = .fillEqually
            nameBrandStackView.spacing = -60
            infoStackView.addArrangedSubview(nameBrandStackView)

            let brandLabel = UILabel()
            brandLabel.text = "\(brands[i])"
            brandLabel.textAlignment = .center
            brandLabel.textColor = .black
            brandLabel.font = UIFont.systemFont(ofSize: 14)
            nameBrandStackView.addArrangedSubview(brandLabel)
            
            let nameLabel = UILabel()
            nameLabel.text = "\(names[i])"
            nameLabel.textAlignment = .center
            nameLabel.textColor = .black
            nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
            nameBrandStackView.addArrangedSubview(nameLabel)
            
            let priceLabel = UILabel()
            priceLabel.text = "₺\(prices[i])"
            priceLabel.textAlignment = .center
            priceLabel.textColor = .black
            priceLabel.font = UIFont.systemFont(ofSize: 14)
            nameBrandStackView.addArrangedSubview(priceLabel)
            
            let categoryLabel = UILabel()
            categoryLabel.text = "\(categories[i])"
            categoryLabel.textAlignment = .center
            categoryLabel.textColor = .black
            categoryLabel.font = UIFont.systemFont(ofSize: 14)
            nameBrandStackView.addArrangedSubview(categoryLabel)
        }
    }
}

extension PageCollectionViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
          let currentIndex = Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
          let maxIndex = min(images.count - 1, 2)
          
          if currentIndex < 0 {
              
              scrollView.contentOffset.x = 0
              
          } else if currentIndex > maxIndex {
              
              scrollView.contentOffset.x = CGFloat(maxIndex) * scrollView.frame.size.width
              
          } else if currentIndex == 2 && scrollView.contentOffset.x > CGFloat(currentIndex) * scrollView.frame.size.width {
              scrollView.contentOffset.x = CGFloat(maxIndex) * scrollView.frame.size.width
          }
        
          pageController.currentPage = Int(floor(scrollView.contentOffset.x / scrollView.frame.size.width))
      }
}
