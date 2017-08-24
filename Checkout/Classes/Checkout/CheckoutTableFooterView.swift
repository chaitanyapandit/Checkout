//
//  CheckoutTableFooterView.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit
import SnapKit

// Displays all the content below the "TOTAL"
// Includes By tapping you agree... checkbox button and Cash me outside button
class CheckoutTableFooterView: UIView {
    
    var termsLabel: UILabel!
    var checkBoxButton: UIButton!
    var acceptTermsButton: UIButton!
    var checkoutButton: UIButton!
    var checkoutActivityIndicator: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // "By tapping you agree ..."
        termsLabel = UILabel()
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.top.equalToSuperview().offset(25)
        }
        termsLabel.numberOfLines = 0
        termsLabel.font = UIFont.mediumFontWithSize(12)
        termsLabel.textColor = UIColor.lighterGray
        termsLabel.text = "checkout:terms-conditions".localized
        
        // ✅
        checkBoxButton = UIButton()
        addSubview(checkBoxButton)
        checkBoxButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.termsLabel).offset(2)
            make.top.equalTo(self.termsLabel.snp.bottom).offset(6.0)
            make.width.equalTo(30.0)
            make.height.equalTo(50.0)
        }
        checkBoxButton.setImage(UIImage(named:"check-off"), for: .normal)
        checkBoxButton.setImage(UIImage(named:"check-on"), for: .selected)
        checkBoxButton.setImage(UIImage(named:"check-on"), for: .highlighted)
        checkBoxButton.accessibilityIdentifier = "checkout:checkbox-button"
        
        // "I agree with the terms and conditions of service"
        acceptTermsButton = UIButton()
        addSubview(acceptTermsButton)
        acceptTermsButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.checkBoxButton.snp.right).offset(7)
            make.centerY.equalTo(self.checkBoxButton)
        }
        acceptTermsButton.setTitleColor(UIColor.lighterGray, for: .normal)
        acceptTermsButton.setTitleColor(UIColor.blue, for: .highlighted)
        acceptTermsButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        acceptTermsButton.setTitle("checkout:terms-button-title".localized, for: .normal)
        
        // "Cash me outside"
        checkoutButton = UIButton()
        addSubview(checkoutButton)
        checkoutButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.acceptTermsButton.snp.bottom).offset(21)
        }
        checkoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        checkoutButton.contentEdgeInsets = UIEdgeInsetsMake(12, 40, 12, 40)
        checkoutButton.setTitleColor(UIColor.diffusedBlack, for: .normal)
        checkoutButton.setTitleColor(UIColor.blue, for: .highlighted)
        checkoutButton.setTitleColor(UIColor.gray.withAlphaComponent(0.7), for: .disabled)
        checkoutButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        checkoutButton.layer.borderWidth = 1.5
        checkoutButton.setTitle("checkout:checkout-button-title".localized, for: .normal)
        checkoutButton.accessibilityIdentifier = "checkout:checkout-button"
        
        // Spinner to indicate checkout is in progress
        checkoutActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        addSubview(checkoutActivityIndicator)
        checkoutActivityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(checkoutButton)
        }
        checkoutActivityIndicator.hidesWhenStopped = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkoutButton.layer.cornerRadius = checkoutButton.frame.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// Displays "TOTAL" and separators above and below
class CheckoutTableSectionFooterView : UITableViewHeaderFooterView {
    
    var topSeparator: UIView!
    var bottomSeparator: UIView!
    var titleLabel: UILabel!
    var valueLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        // -------------
        topSeparator = UIView()
        addSubview(topSeparator)
        self.topSeparator.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(17)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        topSeparator.backgroundColor = UIColor.separator
        
        // "TOTAL"
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(15)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.mediumFontWithSize(15)
        titleLabel.textColor = UIColor.diffusedBlack
        titleLabel.text = "checkout:total".localized
        
        // Value of total amount
        valueLabel = UILabel()
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.titleLabel)
        }
        valueLabel.font = UIFont.mediumFontWithSize(15.0)
        valueLabel.textColor = UIColor.diffusedBlack
        valueLabel.textAlignment = .center
        
        // -------------
        bottomSeparator = UIView()
        addSubview(bottomSeparator)
        self.bottomSeparator.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        bottomSeparator.backgroundColor = UIColor.separator
    }
    
    class func reuseIdentifier() -> String {
        return "CheckoutTableSectionFooterViewIdentifier"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
