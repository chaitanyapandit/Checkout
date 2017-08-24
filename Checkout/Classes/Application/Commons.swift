//
//  Commons.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import Foundation

struct API {
    static let stripePublishableKey = "pk_test_U79UiObSouzFe1mgR3DmVI7X"
    static let stripeURL = "https://stripe00.herokuapp.com/"
}

struct OrderItem {
    var title :String
    var value: Float
}

struct Order {
    var currency: String
    var items: [OrderItem]
    var tax: Float = 0.0
    var discount: Float = 0.0 // Applied before tax
    
    // Just the total of items in our cart not accounting for tax
    // Considers discount
    // Discount is a positive integer that gets subtracted from the item total
    func itemTotal() -> Float {
        return items.reduce(Float(0.0), { acc, y in
            return acc + y.value
        }) - self.discount
    }
    
    // Just the tax component on the items in card
    func taxComponent() -> Float {
        return itemTotal() * self.tax / Float(100)
    }
    
    // Grant total with tax added
    func grandTotal() -> Float {
        return itemTotal() + taxComponent()
    }
}
