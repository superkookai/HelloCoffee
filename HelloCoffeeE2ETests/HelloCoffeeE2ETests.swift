//
//  HelloCoffeeE2ETests.swift
//  HelloCoffeeE2ETests
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import XCTest

final class when_app_is_launch_with_no_orders: XCTestCase {

    @MainActor
    func test_should_make_sure_no_orders_message_is_display() throws {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV":"TEST"]
        app.launch()
        
        XCTAssertEqual("No orders available!", app.staticTexts["noOrdersText"].label)
    }

}

final class when_adding_a_new_coffee_order: XCTestCase {
    private var app: XCUIApplication!
    
    //call before running each test
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV":"TEST"]
        app.launch()
        
        //goto place order screen
        app.buttons["addNewOrderButton"].tap()
        
        //fill out textfields
        let nameTextField = app.textFields["name"]
        let coffeeTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Jimmy")
        
        coffeeTextField.tap()
        coffeeTextField.typeText("Hot Cope")
        
        priceTextField.tap()
        priceTextField.typeText("4.5")
        
        //place order
        placeOrderButton.tap()
    }
    
    //call after running each test
    override func tearDown() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else { return }
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
    func test_should_display_coffee_order_in_list_successfully() throws {
        XCTAssertEqual("Jimmy", app.staticTexts["orderNameText"].label)
        XCTAssertEqual("Hot Cope, Medium", app.staticTexts["coffeeNameAndSizeText"].label)
        XCTAssertEqual("$4.50", app.staticTexts["coffeePriceText"].label)
    }
    
    
}
