//
//  CheckoutUITests.swift
//  CheckoutUITests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import XCTest
import Stripe

class CheckoutUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Env variable so that during runtime we know if we're in UITesting
        let app = XCUIApplication()
        app.launchEnvironment = ["UITESTING":"TRUE"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Helper function that waits for a UI element to appear on the screen with a timeout of 20 sec
    func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 20) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    // Ensure that the checkout button is disabled initially even though the box is checked, disabled because no card is added yet
    func testCheckoutButton() {
        let app = XCUIApplication()
        app.buttons["checkout:checkbox-button"].tap()
        XCTAssertEqual(app.buttons["checkout:checkout-button"].isEnabled, false, "Checkout button should be disabled if terms checked but no card")
    }
    
    // UI Flow:
    // Taps "Add Payment Method" button to present the PaymenMethod ViewController (Where we add/select cards)
    // Taps "Add New Card..." in the PaymenMethod ViewController to internally add a dummy card
    // Wait for the dummy card to ve verified via Stripe
    // Wait for the card cell to appear in the list of cards
    // Tap done to go back to the Checkout view
    // Check the Terms and conditions box
    // Tap "Cash me outside" to initiate a payment
    // Wait for Payment Success screen to appear
    func testAddPaymentAndCheckout() {
        let app = XCUIApplication()
        
        // Tap "Add Payment Method" button
        // This launches the PaymentMethodViewController
        app.buttons["checkout:add-payment-button"].tap()
        
        // Tap "Add New Card..." cell
        // This will internally add a test card detecting we're running a UI Test
        let addCardCell = app.cells["payment:new-card-cell"]
        waitForElementToAppear(element: addCardCell)
        addCardCell.tap()
        
        // Wait for the card to be added via Stripe and tableview to display that card cell
        let cardCell = app.cells["payment:card-cell"]
        waitForElementToAppear(element: cardCell)
        
        // Dismiss Add Payment Method View Controller
        app.buttons["payment:done"].tap()
        
        // Wait for the "Cash me outside" button to appear, which indicates that we're on the Checkout screen
        let checkoutButton = app.buttons["checkout:checkout-button"]
        waitForElementToAppear(element: checkoutButton)
        
        // Check the terms and conditions checkbox
        app.buttons["checkout:checkbox-button"].tap()
        XCTAssertEqual(checkoutButton.isEnabled, true, "Checkout button should be enabled if terms checked and card is added")
        
        // Tap "Cash me outside" button which will trigger a payment
        // Then just wait for the PaymentSuccess screen to appear
        checkoutButton.tap()
        waitForElementToAppear(element: app.buttons["success:footer-button"])
    }
}
