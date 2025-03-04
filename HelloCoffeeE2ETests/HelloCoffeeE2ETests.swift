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

final class when_deleting_an_order: XCTestCase {
    private var app: XCUIApplication!
    
    //call before running each test
    override func setUp() {
        clearServerData()
        
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
        nameTextField.typeText("Joey")
        
        coffeeTextField.tap()
        coffeeTextField.typeText("Hot Latte")
        
        priceTextField.tap()
        priceTextField.typeText("5.5")
        
        //place order
        placeOrderButton.tap()
        
    }
    
    //call after running each test
    override func tearDown() {
        clearServerData()
    }
    
    func clearServerData() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else { return }
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
    func test_should_delete_order_successfully() throws {
        let collectionViewsQuery = XCUIApplication().collectionViews
        let cellsQuery = collectionViewsQuery.cells
        let element = cellsQuery.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.swipeLeft()
        collectionViewsQuery.buttons["Delete"].tap()
        
        let orderList = app.collectionViews["orderList"]
        XCTAssertEqual(0, orderList.cells.count)
    }
}

final class when_updating_an_existing_order: XCTestCase {
    private var app: XCUIApplication!
    
    //call before running each test
    override func setUp() {
        clearServerData()
        
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
        nameTextField.typeText("Samantha")
        
        coffeeTextField.tap()
        coffeeTextField.typeText("Tea")
        
        priceTextField.tap()
        priceTextField.typeText("2.5")
        
        //place order
        placeOrderButton.tap()
        
        
    }
    
    //call after running each test
    override func tearDown() {
        clearServerData()
    }
    
    func clearServerData() {
        Task {
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else { return }
            let (_, _) = try! await URLSession.shared.data(from: url)
        }
    }
    
    func test_should_update_order_successfully() throws {
        // go to the order screen
        let orderList = app.collectionViews["orderList"]
                orderList.buttons["orderNameText-coffeeNameAndSizeText-coffeePriceText"].tap()
        
        app.buttons["editOrderButton"].tap()
        
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        let _ = nameTextField.waitForExistence(timeout: 2.0)
        nameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        nameTextField.typeText("Samantha Edit")
        
        let _ = coffeeNameTextField.waitForExistence(timeout: 10.0)
        coffeeNameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        coffeeNameTextField.typeText("Coffee")
        
        let _ = priceTextField.waitForExistence(timeout: 2.0)
        priceTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        priceTextField.typeText("1.50")
        
        placeOrderButton.tap()
        
        XCTAssertEqual("Coffee", app.staticTexts["coffeeNameText"].label)
    }
}
