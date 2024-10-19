//
//  InnovaFinalUITests.swift
//  InnovaFinalUITests
//
//  Created by Mert AKBAŞ on 7.10.2024.
//

import XCTest

final class InnovaFinalUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("******** UITest ********")
    }
    
    func test_navigate_home_to_detail_view_controller() {
        app.launch()
        sleep(1)
        
        XCTAssertTrue(app.isSearchBarDisplayed)
        XCTAssertTrue(app.isCollectionViewDisplayed)
        
        sleep(1)
        
        app.searchBar.tap()
        app.searchBar.typeText("Saat")
        app.keyboards.buttons["Ara"].tap()
       
        let firstCell = app.collectionView.cells.element(boundBy: 0)
        firstCell.tap()
   
        sleep(1)
        
        XCTAssertTrue(app.isProductImageViewDisplayed)
        XCTAssertTrue(app.isBrandLabelDisplayed)
        XCTAssertTrue(app.isNameLabelDisplayed)
        XCTAssertTrue(app.isNumberLabelDisplayed)
        XCTAssertTrue(app.isTotalPriceDisplayed)
        XCTAssertTrue(app.isPriceLabelDisplayed)
        
        sleep(1)
        
        app.upperButton.tap()
        app.upperButton.tap()
        
        sleep(2)
        
        app.addProductButton.tap()
        sleep(3)
    }

  
}

extension XCUIApplication {
    
    var searchBar: XCUIElement! {
        otherElements["searchBar"]
    }
 
    var collectionView: XCUIElement! {
        collectionViews["collectionView"]
    }
    
    var addProductButton: XCUIElement! {
        buttons["addProductButton"]
    }
    
    var upperButton: XCUIElement! {
        buttons["upperButton"]
    }
    
    var productImageView: XCUIElement! {
        images.matching(identifier: "productImageView").element
    }
    
    var brandLabel: XCUIElement! {
        staticTexts.matching(identifier: "brandLabel").element
    }
    
    var nameLabel: XCUIElement! {
        staticTexts.matching(identifier: "nameLabel").element
    }
    
    var numberLabel: XCUIElement! {
        staticTexts.matching(identifier: "numberLabel").element
    }
    
    var totalPrice: XCUIElement! {
        staticTexts.matching(identifier: "totalPrice").element
    }
    
    var priceLabel: XCUIElement! {
        staticTexts.matching(identifier: "priceLabel").element
    }
    
    var isSearchBarDisplayed: Bool {
        searchBar.exists
    }
    
    var isCollectionViewDisplayed: Bool {
        collectionView.exists
    }
    
    var isProductImageViewDisplayed: Bool {
        productImageView.exists
    }
    
    var isBrandLabelDisplayed: Bool {
        brandLabel.exists
    }
    
    var isNameLabelDisplayed: Bool {
        nameLabel.exists
    }
    
    var isNumberLabelDisplayed: Bool {
        numberLabel.exists
    }
    
    var isTotalPriceDisplayed: Bool {
        totalPrice.exists
    }
    
    var isPriceLabelDisplayed: Bool {
        priceLabel.exists
    }
}
