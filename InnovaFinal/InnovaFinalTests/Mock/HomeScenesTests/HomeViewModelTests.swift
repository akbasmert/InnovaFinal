//
//  HomeViewModelTests.swift
//  InnovaFinalTests
//
//  Created by Mert AKBAŞ on 16.10.2024.
//

import XCTest
@testable import InnovaFinalAPI
@testable import InnovaFinal


final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var view: MockHomeViewController!

    override func setUp() {
        super.setUp()
        view = MockHomeViewController()
        viewModel = HomeViewModel(service: HomeService())
        viewModel.delegate = view
    }
    
    override func tearDown() {
        view = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.isInvokedSetupCollectionView)
        XCTAssertFalse(view.isInvokedSetupSearchBar)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(view.isInvokedSetupCollectionView)
        XCTAssertTrue(view.isInvokedSetupSearchBar)
    }

    func test_fetchProducts() {
        XCTAssertFalse(view.isInvokedHideLoading)
        XCTAssertFalse(view.isInvokedReloadData)

        viewModel.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.view.isInvokedHideLoading)
            XCTAssertTrue(self.view.isInvokedReloadData)
        }
    }

}

extension Product {
    static var response: Product {
        let bundle = Bundle(for: HomeViewModelTests.self)
        let path = bundle.path(forResource: "Products", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let decoder = Decoders.dateDecoder
        let response = try! decoder.decode(Product.self, from: data)
        return response
    }
}
