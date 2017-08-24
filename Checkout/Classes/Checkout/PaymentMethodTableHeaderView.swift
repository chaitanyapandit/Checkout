//
//  AddCardTableHeaderView.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit

// Displays the card image on top to mimic the Stripe's ui
class PaymentMethodTableHeaderView: UIView {
    
    var cardImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Card image
        cardImageView = UIImageView()
        self.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.8)
            make.width.equalTo(self).multipliedBy(0.5)
        }
        cardImageView.image = UIImage(named: "StripeCreditCard")
        cardImageView.contentMode = .scaleAspectFit
        self.backgroundColor = UIColor(hexString: "#f2f2f5")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
