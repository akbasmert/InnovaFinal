//
//  SplashViewModel.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import Foundation
import InnovaFinalAPI

protocol SplashViewModelProtocol {
    
    var delegate: SplashViewModelDelegate? { get set }
    
    func internetConnection()
}

protocol SplashViewModelDelegate: AnyObject {
    
    func showLoadingView()
    func hideLoadingView()
    func noInternetConnection()
    func toHomeViewController()
}

final class SplashViewModel {
    
    static let shared = SplashViewModel(service: HomeService())
    
    let service: HomeServiceProtocol
    weak var delegate: SplashViewModelDelegate?
    private var products: [Product] = []
    
    init(service: HomeServiceProtocol) {
        self.service = service
    }
}

extension SplashViewModel: SplashViewModelProtocol {
  
    func internetConnection() {
        if service.isConnectedToInternet() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.delegate?.toHomeViewController()
            }
        } else {
            self.delegate?.noInternetConnection()
        }
    }
}
