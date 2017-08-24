//
//  AddPaymentMethodViewController.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit
import Stripe

protocol PaymentMethodControllerDelegate {
    func didSelectToken(token: STPToken?)
}

class PaymentMethodViewController: UIViewController {

    var paymentContext: STPPaymentContext? // Payment context passed to us by checkout view controller
    var tableView: UITableView!
    var doneButtonItem: UIBarButtonItem!
    var activityIndicatorItem: UIBarButtonItem! // Activity indicator item to wrap the actual activity indicator view
    var activityIndicator: UIActivityIndicatorView! // Activity indicator view to indicate we're verifing card information
    var delegate: PaymentMethodControllerDelegate?
    var savedTokens = [STPToken]() // Saved tokens for each card
    
    // Updated when a user selects a different card from the tableview
    var selectedToken: STPToken? {
        didSet {
            if self.selectedToken?.card != nil {
                self.doneButtonItem.isEnabled = true
            }
        }
    }
    
    // Indicated we're verifying a card added from card.io
    var busy: Bool = false {
        didSet {
            if busy {
                if (!self.activityIndicator.isAnimating) {
                    self.activityIndicator.startAnimating()
                }
                
                if (self.navigationItem.rightBarButtonItem != self.activityIndicatorItem) {
                    self.navigationItem.setRightBarButton(self.activityIndicatorItem, animated: true)
                }
            } else {
                
                self.activityIndicator.stopAnimating()
                if (self.navigationItem.rightBarButtonItem != self.doneButtonItem) {
                    self.navigationItem.setRightBarButton(doneButtonItem, animated: true)
                }
            }
        }
    }
    
    // Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // Used in UITesting since we can't add accessibilityIdentifiers to Card.IO's view elements
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "UITEST-AddCard"), object: nil, queue: nil) { (notification) in
            if let card = notification.object as? STPCardParams {
                self.addCard(card: card)
            }
        }
    }
    
    // Setup views and their constraints
    func setupViews() {
        
        // Cancel buttion on the left in nav bar
        self.navigationItem.setHidesBackButton( false, animated: true)
        let leftBarButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(sender: )))
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        // Done button on the right in the nav bar
        doneButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneAction(sender: )))
        self.navigationItem.setRightBarButton(doneButtonItem, animated: true)
        doneButtonItem.isEnabled = false
        doneButtonItem.accessibilityIdentifier = "payment:done"

        // Activity indicator that overlays the done button
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)

        // Tableview
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor(hexString: "#f2f2f5")
        
        // Displays the dummy card image
        self.tableView.tableHeaderView = PaymentMethodTableHeaderView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.3))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PaymentMethodCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func reload () {
        tableView.reloadData()
    }
    
    func addCard(card: STPCardParams) {
        
        self.busy = true
        
        // Send to Stripe
        STPAPIClient.shared().createToken(withCard: card) { (stpToken, error) in
            if let token = stpToken {
                DispatchQueue.main.async {
                    self.savedTokens.append(token)
                    if (self.selectedToken == nil) {
                        self.selectedToken = self.savedTokens.first
                    }
                    self.reload()
                    self.busy = false
                }
            } else {
                print(error!)
                self.busy = false
            }
        }
    }
    
    func cancelAction(sender : UIButton) {
        self.dismiss(animated: true)
    }
    
    func doneAction(sender : UIButton) {
        self.delegate?.didSelectToken(token: self.selectedToken)
        self.dismiss(animated: true)
    }
}

extension PaymentMethodViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return self.savedTokens.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath)
            let token = self.savedTokens[indexPath.row]
            if let card = token.card {
                cell.imageView?.image = card.image
                cell.textLabel?.text =  String(format: "payment:cell-card-name".localized, STPCard.string(from: card.brand), card.last4())
                
                if (self.selectedToken?.card == card) {
                    cell.isSelected = true
                    cell.accessoryType = .checkmark
                    cell.textLabel?.textColor = UIColor.stripeBlue
                } else {
                    cell.isSelected = false
                    cell.accessoryType = .none
                    cell.textLabel?.textColor = UIColor.diffusedBlack
                }
            }
            
            cell.accessibilityIdentifier = "payment:card-cell"

            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "payment:cell-new-card".localized
            cell.imageView?.image = UIImage(named: "addCard")
            cell.textLabel?.textAlignment = .justified
            cell.textLabel?.textColor = UIColor.stripeBlue
            cell.accessibilityIdentifier = "payment:new-card-cell"
            
            return cell
        }
    }
}

extension PaymentMethodViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if let testing = ProcessInfo.processInfo.environment["UITESTING"], testing == "TRUE" {
                let card: STPCardParams = STPCardParams()
                card.number = "4242424242424242"
                card.expMonth = 12
                card.expYear = 20
                card.cvc = "123"
                addCard(card: card)
            } else  if let cardIOVC = CardIOPaymentViewController.init(paymentDelegate: self) {
                cardIOVC.collectCVV = true
                cardIOVC.collectCardholderName = true
                cardIOVC.collectExpiry = true
                cardIOVC.hideCardIOLogo = true
                self.present(cardIOVC, animated: true) {
                }
            }
            
            DispatchQueue.main.async {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        } else if (self.savedTokens.count > indexPath.row) {
            self.selectedToken = self.savedTokens[indexPath.row]
            self.reload()
        }
    }
}

extension PaymentMethodViewController : CardIOPaymentViewControllerDelegate {
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
        //dismiss scanning controller
        paymentViewController?.dismiss(animated: true, completion: nil)
        
        //create Stripe card
        let card: STPCardParams = STPCardParams()
        card.number = cardInfo.cardNumber
        card.expMonth = cardInfo.expiryMonth
        card.expYear = cardInfo.expiryYear
        card.cvc = cardInfo.cvv
        
        addCard(card: card)
    }
}
