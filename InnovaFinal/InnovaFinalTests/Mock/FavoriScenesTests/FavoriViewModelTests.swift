//
//  FavoriViewModelTests.swift
//  InnovaFinalTests
//
//  Created by Mert AKBAŞ on 16.10.2024.
//

import XCTest
@testable import InnovaFinal
@testable import InnovaFinalAPI

final class FavoriViewModelTests: XCTestCase {

    var viewModel: FavoriteViewModel!
    var view: MockFavoriteViewController!
      
    override func setUp() {
        super.setUp()
        view = MockFavoriteViewController()
        viewModel = FavoriteViewModel(service: HomeService())
        viewModel.delegate = view
    }

    override func tearDown() {
        view = nil
        viewModel = nil
        super.tearDown()
    }
        
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.isInvokedSetupTableView)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(view.isInvokedSetupTableView)
    }
    
    func test_fetchFilteredProducts() {
        XCTAssertFalse(view.isInvokedHideLoading)
        XCTAssertFalse(view.isInvokedReloadData)
        
        viewModel.saveFilteredProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.view.isInvokedHideLoading)
            XCTAssertTrue(self.view.isInvokedReloadData)
        }
    }
}
