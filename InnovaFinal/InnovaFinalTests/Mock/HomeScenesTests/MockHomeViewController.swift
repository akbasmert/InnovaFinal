//
//  MockHomeViewController.swift
//  InnovaFinalTests
//
//  Created by Mert AKBAŞ on 16.10.2024.
//

import Foundation
@testable import InnovaFinal

final class MockHomeViewController: HomeViewModelDelegate {
    
    var isInvokedSetupCollectionView = false
    var invokedSetupCollectionViewCount = 0
    
    func setupCollectionView() {
        isInvokedSetupCollectionView = true
        invokedSetupCollectionViewCount += 1
    }
    
    var isInvokedSetupSearchBar = false
    var invokedSetupSearchBarCount = 0

    func setupSearchBar() {
        isInvokedSetupSearchBar = true
        invokedSetupSearchBarCount += 1
    }
    
    var isInvokedShowLoading = false
    var invokedShowLoadingCount = 0
    
    func showLoadingView() {
        isInvokedShowLoading = true
        invokedShowLoadingCount += 1
    }
    
    var isInvokedHideLoading = false
    var invokedHideLoadingCount = 0
    
    func hideLoadingView() {
        isInvokedHideLoading = true
        invokedHideLoadingCount += 1
    }
    
    var isInvokedReloadData = false
    var invokedReloadDataCount = 0
    
    func reloadData() {
        isInvokedReloadData = true
        invokedReloadDataCount += 1
    }
    

}
