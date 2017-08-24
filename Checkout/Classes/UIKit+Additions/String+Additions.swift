//
//  String+Additions.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit

extension String {

    // Handy var to generate a localized string
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
