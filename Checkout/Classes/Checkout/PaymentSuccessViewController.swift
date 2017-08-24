//
//  PaymentSuccessViewController.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit

// The final screen displaying payment success
class PaymentSuccessViewController: UIViewController {
    
    var topContainerView: UIView!
    var statusLabel: UILabel!
    var quoteLabel: UILabel!
    var footerButton: UIButton!
    
    // Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // Setup views and their constraints
    func setupViews() {
        
        self.view.backgroundColor = UIColor.white

        // Container for the top image
        topContainerView = UIView()
        self.view.addSubview(topContainerView)
        topContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(22)
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.4)
        }
        
        // Champagne bottle image
        let completedImageView = UIImageView(image: UIImage(named: "success"))
        topContainerView.addSubview(completedImageView)
        completedImageView.snp.makeConstraints { (make) in
            make.center.equalTo(topContainerView)
        }
        
        // "Your car is covered!"
        statusLabel = UILabel()
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topContainerView.snp.bottom).offset(50)
            make.centerX.equalTo(self.view)
        }
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.mediumFontWithSize(22)
        statusLabel.textColor = UIColor.diffusedBlack
        statusLabel.text = "success:title".localized
        
        // "Something about easy claims and we're here for you whatever whatever,yay!"
        quoteLabel = UILabel()
        view.addSubview(quoteLabel)
        quoteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(37)
            make.left.equalTo(view).offset(50)
            make.right.equalTo(view).offset(-50)
        }
        quoteLabel.textAlignment = .center
        quoteLabel.numberOfLines = 0
        quoteLabel.font = UIFont.regularFontWithSize(18)
        quoteLabel.textColor = UIColor.darkerGray
        quoteLabel.text = "success:message".localized
        
        // "How bow dah!"
        footerButton = UIButton()
        view.addSubview(footerButton)
        footerButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-48)
            make.centerX.equalTo(self.view)
        }
        footerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footerButton.contentEdgeInsets = UIEdgeInsetsMake(10, 45, 10, 45)
        footerButton.setTitleColor(UIColor.diffusedBlack, for: .normal)
        footerButton.setTitleColor(UIColor.blue, for: .highlighted)
        footerButton.layer.borderColor = UIColor.diffusedBlack?.cgColor
        footerButton.layer.borderWidth = 1.5
        footerButton.setTitle("success:done-button-title".localized, for: .normal)
        footerButton.addTarget(self, action: #selector(dismissAction(sender:)), for: .touchUpInside)
        footerButton.accessibilityIdentifier = "success:footer-button"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerButton.layer.cornerRadius = footerButton.frame.height / 2
    }
    
    func dismissAction(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
