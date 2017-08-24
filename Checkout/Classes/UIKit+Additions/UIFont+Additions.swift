//
//  UIFont+Additions.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit

extension UIFont {

    // Helper functions to generate custom fonts
    class func regularFontWithSize(_ size : CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Regular", size: size)
    }
    
    class func mediumFontWithSize(_ size : CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Medium", size: size)
    }
}
