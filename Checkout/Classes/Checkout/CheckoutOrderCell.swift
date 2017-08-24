//
//  CheckoutOrderCell.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit

// Displays the name of the item on the left and the cost on right
class CheckoutOrderCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var valueLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // "Yearly Protection Plan" for example
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalToSuperview().offset(15)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.regularFontWithSize(15)
        titleLabel.textColor = UIColor.lighterGray
        
        // $ xx.xx
        valueLabel = UILabel()
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.titleLabel)
        }
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.regularFontWithSize(15)
        valueLabel.textColor = UIColor.lighterGray

        //No separator between order detail cells
        self.separatorInset = UIEdgeInsetsMake(0, 100000, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func reuseIdentifier() -> String {
        return "CheckoutOrderCellIdentifier"
    }
}
