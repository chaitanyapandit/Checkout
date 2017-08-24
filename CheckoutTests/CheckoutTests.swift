//
//  CheckoutTests.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import XCTest
@testable import Checkout

class CheckoutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test to verify an order total which has no tax but has discount
    func testOrderNoTax() {
        let order = Order(currency:"$", items:[OrderItem(title: "Yearly Protection Plan", value: 72.99)], tax: 0.0, discount:5.0)
        XCTAssertEqual(order.grandTotal(), Float(67.99), "Test Failed for order with no tax")
    }
    
    // Test to verify an order total which has no discount but has tax
    func testOrderNoDiscount() {
        let order = Order(currency:"$", items:[OrderItem(title: "Yearly Protection Plan", value: 50.0)], tax: 10.0, discount:0.0)
        XCTAssertEqual(order.grandTotal(), Float(55.0), "Test Failed for order with no discount")
    }
    
    // Test to verify an order total which has no discount and no tax
    func testOrderNoTaxNoDiscount() {
        let order = Order(currency:"$", items:[OrderItem(title: "Yearly Protection Plan", value: 50.0)], tax: 0.0, discount:0.0)
        XCTAssertEqual(order.grandTotal(), Float(50.0), "Test Failed for order with no tax and discount")
    }
    
    // Test to verify an order total which has both discount and tax
    func testOrderTaxAndDiscount() {
        let order = Order(currency:"$", items:[OrderItem(title: "Yearly Protection Plan", value: 50.0)], tax: 10.0, discount:5.0)
        XCTAssertEqual(order.grandTotal(), Float(49.5), "Test Failed for order with tax and discount")
    }
}
