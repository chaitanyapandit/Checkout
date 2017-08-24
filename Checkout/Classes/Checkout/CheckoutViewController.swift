//
//  CheckoutViewController.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit
import Stripe

class CheckoutViewController: UIViewController {

    var tableView: UITableView!
    var tableHeaderView: CheckoutTableHeaderView!
    var tableFooterView: CheckoutTableFooterView!
    var paymentContext: STPPaymentContext!
    var order = Order(currency:"$", items:[OrderItem(title: "Yearly Protection Plan", value: 72.99)], tax: 0.0, discount:5.0) {
        didSet {
            reload()
        }
    }

    // The Stripe token for the selected card we got after adding a card
    var selectedToken: STPToken? {
        didSet {
            reload()
            updateCheckoutButton()
        }
    }
    
    // Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        reload()
        setupPaymentContext()
    }

    // Sets up all the vires and their constraints
    func setupViews() {
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.backgroundColor = UIColor.white
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        tableHeaderView = CheckoutTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 221.0))
        tableHeaderView.addPaymentMethodButton.addTarget(self, action: #selector(addPaymentMethodAction(sender:)), for: .touchUpInside)
        tableView.tableHeaderView = tableHeaderView
        
        tableFooterView = CheckoutTableFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height * 0.4)))
        tableFooterView.acceptTermsButton.addTarget(self, action: #selector(acceptTermsAction(sender:)), for: .touchUpInside)
        tableFooterView.checkBoxButton.addTarget(self, action: #selector(checkboxAction(sender:)), for: .touchUpInside)
        tableFooterView.checkoutButton.addTarget(self, action: #selector(checkoutAction(sender:)), for: .touchUpInside)
        tableFooterView.checkoutButton.isEnabled = false
        tableView.tableFooterView = tableFooterView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) // Margin for the separator from view
        
        tableView.register(CheckoutTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CheckoutTableSectionHeaderView.reuseIdentifier())
        tableView.register(CheckoutTableSectionFooterView.self, forHeaderFooterViewReuseIdentifier: CheckoutTableSectionFooterView.reuseIdentifier())
        tableView.register(CheckoutOrderCell.self, forCellReuseIdentifier: CheckoutOrderCell.reuseIdentifier())
    }
    
    // Setup the stripe's payment context
    func setupPaymentContext() {
        let paymentConfiguration = STPPaymentConfiguration.shared()
        paymentConfiguration.publishableKey = API.stripePublishableKey
        self.paymentContext = STPPaymentContext(apiAdapter: StripeAPIAdapter.sharedClient, configuration: paymentConfiguration, theme: STPTheme.default())
        let userInfo = STPUserInformation()
        paymentContext.prefilledInformation = userInfo
        self.paymentContext.delegate = self
        self.paymentContext.hostViewController = self
        self.paymentContext.paymentCurrency = "usd"
    }
    
    // Reloads the contents, the tableview and the add card button
    func reload() {
        
        if let card = self.selectedToken?.card {
            let cardString = String(format: "checkout:selected-card-format".localized, STPCard.string(from: card.brand), card.last4())
            tableHeaderView.addPaymentMethodButton.setTitle(cardString, for: .normal)
        } else {
            tableHeaderView.addPaymentMethodButton.setTitle("checkout:add-payment-method".localized, for: .normal)
        }
        
        self.tableView.reloadData()
        updateCheckoutButton()
    }
    
    // Autoenable checkout button
    func updateCheckoutButton() {
        self.tableFooterView.checkoutButton.isEnabled = self.selectedToken?.card != nil && self.tableFooterView.checkBoxButton.isSelected
    }
    
    // MARK: - Button Actions
    
    // Shows the payment metnod view controller where you can add card
    func addPaymentMethodAction(sender : UIButton) {
        let paymentMethodViewController = PaymentMethodViewController()
        paymentMethodViewController.paymentContext = self.paymentContext
        paymentMethodViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: paymentMethodViewController)
        self.present(navigationController, animated: true)
    }
    
    // I agree
    func checkboxAction(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        updateCheckoutButton()
    }
    
    // Just display a dummy PDF, eventually we'll display actual terms and conditions
    func acceptTermsAction(sender : UIButton){
        if let pdfURl = Bundle.main.url(forResource: "Terms and Conditions", withExtension: "pdf") {
            let docViewCon = UIDocumentInteractionController(url:pdfURl)
            docViewCon.delegate = self
            docViewCon.presentPreview(animated: true)
        }
    }
    
    // Begin the checkout process
    func checkoutAction(sender : UIButton) {
        
        // Disable the checkout button while we're checking out, just for sanity
        tableFooterView.checkoutButton.alpha = 0.0
        tableFooterView.checkoutActivityIndicator.startAnimating()

        // Complete the payment using the token we got when adding a card
        // amount is *100 because Stripe charges in lowest denomination i.e cents
        StripeAPIAdapter.sharedClient.completePayment(tokenId: (self.selectedToken?.stripeID)!, amount: Int(self.order.grandTotal()*100)) { (error) in
            
            // A token can be used only once
            self.selectedToken = nil
            self.tableFooterView.checkoutButton.alpha = 1.0
            self.tableFooterView.checkoutActivityIndicator.stopAnimating()

            if (error == nil) {
                // Success, show the success screen
                let viewController = PaymentSuccessViewController()
                self.present(viewController, animated: true, completion: nil)
            } else {
                // Show an alert
                let alert = UIAlertController(title: "ERROR", message: "Your Payment Failed. Please Try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

typealias TableViewDataSource = CheckoutViewController
extension TableViewDataSource: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Taxes and discount are displayed in two additional cells
        // But discount cell is hidden if no discount is available
        var retVal = self.order.items.count + 1 // One for Tax and Fees
        if (abs(self.order.discount) != 0) {
            retVal = retVal + 1 // one for discount
        }
        return retVal
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutOrderCell.reuseIdentifier(), for: indexPath) as? CheckoutOrderCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.textColor = UIColor.lighterGray
        
        if (indexPath.row < self.order.items.count) { // Order item
            let item = order.items[indexPath.row]
            cell.titleLabel.text = item.title
            cell.valueLabel.text = String(format: "%@%.2f", self.order.currency, item.value)
        } else if (indexPath.row == self.order.items.count) { // Tax and Fees
            cell.titleLabel.text = "checkout:tax-fees".localized
            cell.valueLabel.text = String(format: "%@%.2f", self.order.currency, order.taxComponent())
        } else if (indexPath.row == self.order.items.count + 1) { // Discount
            cell.titleLabel.text = "checkout:discount".localized
            cell.valueLabel.text = String(format: "-%@%.2f", self.order.currency, order.discount)
            cell.valueLabel.textColor = UIColor.discountRed
        }
        
        return cell
    }
}

typealias TableViewDelegate = CheckoutViewController
extension TableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // "Order summary" is displayed in a section header
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CheckoutTableSectionHeaderView.reuseIdentifier()) as? CheckoutTableSectionHeaderView else {
            return nil
        }
                
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // "TOTAL" is displayed in a section footer
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CheckoutTableSectionFooterView.reuseIdentifier())as? CheckoutTableSectionFooterView else {
            return nil
        }
        footerView.valueLabel.text = String(format: "%@%.2f", self.order.currency, self.order.grandTotal())
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
}

typealias PaymentContextDelegate = CheckoutViewController
extension PaymentContextDelegate: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.reload()
    }
    
    // Not applicable for us right now since we're not maintaining users
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        StripeAPIAdapter.sharedClient.completeCharge(paymentResult, amount: Int(self.order.grandTotal()*100), completion: completion)
    }
    
    // Not applicable for us right now since we're not maintaining users
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Purchase complete"
        case .userCancellation:
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Not applicable for us right now since we're not maintaining users
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext?.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
}

// Called by the Payment Method screen when user adds a card for the first time or selects a different card
extension CheckoutViewController: PaymentMethodControllerDelegate {
    func didSelectToken(token: STPToken?) {
        self.selectedToken = token
    }
}

// Delegates for UIDocumentInteractionController we use to present T&C PDF
extension CheckoutViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
