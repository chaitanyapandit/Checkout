//
//  CheckoutTableHeaderView.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit
import SnapKit

// The tableHeader View displays 'Add Payment Method' button
// Basically all the content above "Order Summary"
class CheckoutTableHeaderView: UIView {
    
    var closeButton: UIButton!
    var headerTitleLabel: UILabel!
    var headerSubtitleLabel :UILabel!
    var addPaymentMethodButton: UIButton!
    var topSeparator: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // X
        closeButton = UIButton()
        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(40)
        }
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        
        // "Checkout"
        headerTitleLabel = UILabel()
        self.addSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.closeButton.snp.bottom).offset(17)
            make.left.right.equalToSuperview()
        }
        headerTitleLabel.textAlignment = .center
        headerTitleLabel.font = UIFont.regularFontWithSize(22)
        headerTitleLabel.textColor = UIColor.diffusedBlack
        headerTitleLabel.text = "checkout:title".localized
        
        // "Your coverage begins immediately"
        headerSubtitleLabel = UILabel()
        self.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.headerTitleLabel.snp.bottom).offset(35)
        }
        headerSubtitleLabel.textAlignment = .center
        headerSubtitleLabel.font = UIFont.mediumFontWithSize(12)
        headerSubtitleLabel.textColor = UIColor.diffusedBlack
        headerSubtitleLabel.text = "checkout:subtitle".localized

        // "Add Payment Method"
        addPaymentMethodButton = UIButton()
        self.addSubview(addPaymentMethodButton)
        addPaymentMethodButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(45)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        addPaymentMethodButton.setImage(UIImage(named: "creditcard"), for: .normal)
        addPaymentMethodButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        addPaymentMethodButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addPaymentMethodButton.setTitleColor(UIColor.emeraldGreen, for: .normal)
        addPaymentMethodButton.setTitleColor(UIColor.blue, for: .highlighted)
        addPaymentMethodButton.tintColor = UIColor.purple
        addPaymentMethodButton.accessibilityIdentifier = "checkout:add-payment-button"

        // -------------
        topSeparator = UIView()
        self.addSubview(topSeparator)
        topSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(addPaymentMethodButton).offset(-2)
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        topSeparator.backgroundColor = UIColor.separator
    }
    
    override public var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        var size = super.intrinsicContentSize
        size.height = 200.0

        return size
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// Displays "Order Summary" and separators above and below it
class CheckoutTableSectionHeaderView : UITableViewHeaderFooterView {
    
    var topSeparator :UIView!
    var bottomSeparator: UIView!
    var titleLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white

        // -------------
        topSeparator = UIView()
        addSubview(topSeparator)
        self.topSeparator.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        topSeparator.backgroundColor = UIColor.separator
        
        // "Order Summary"
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topSeparator.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.mediumFontWithSize(15)
        titleLabel.textColor = UIColor.diffusedBlack
        titleLabel.text = "checkout:order-summary".localized
        
        // -------------
        bottomSeparator = UIView()
        addSubview(bottomSeparator)
        self.bottomSeparator.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        bottomSeparator.backgroundColor = UIColor.separator
    }
    
    class func reuseIdentifier() -> String {
        return "CheckoutTableSectionHeaderViewIdentifier"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
