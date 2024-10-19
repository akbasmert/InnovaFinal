//
//  MockFavoriteViewController.swift
//  InnovaFinalTests
//
//  Created by Mert AKBAŞ on 16.10.2024.
//

import Foundation
@testable import InnovaFinal

final class MockFavoriteViewController: FavoriteViewModelDelegate {
    
    var isInvokedSetupTableView = false
    var invokedSetupTableViewCount = 0
    
    func setupTableView() {
         isInvokedSetupTableView = true
         invokedSetupTableViewCount += 1
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
