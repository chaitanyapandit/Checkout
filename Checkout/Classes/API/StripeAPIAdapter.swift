//
//  StripeAPIAdapter.swift
//  CheckoutTests
//
//  Created by Chaitanya Pandit on 24/08/17.
//  Copyright © 2017 Chaitanya Pandit. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class StripeAPIAdapter: NSObject, STPBackendAPIAdapter {
    
    static let sharedClient = StripeAPIAdapter()
    
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = API.stripeURL as String?, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    // Cmplete a payment, the amount is always in the lowest denomination, cents in our case
    func completePayment(tokenId : String, amount: Int, completion: @escaping STPErrorBlock) {
        
        let url = self.baseURL.appendingPathComponent("create_charge")
        Alamofire.request(url, method: .post, parameters: [
            "source": tokenId,
            "amount": amount
            ])
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    if let data = response.data,
                       let errorString = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                        print(String(format:"Payment ERROR: %@", errorString))
                    }
                    completion(error)
            }
        }
    }

    // Not applicable for us right now since we're not maintaining users
    func completeCharge(_ result: STPPaymentResult, amount: Int, completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        Alamofire.request(url, method: .post, parameters: [
            "source": result.source.stripeID,
            "amount": amount
            ])
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
    
    func retrieveCustomer(_ completion: STPCustomerCompletionBlock?) {
        // TODO:
    }
    
    func selectDefaultCustomerSource(_ source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        // TODO:
    }
    
    func attachSource(toCustomer source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        // TODO:
    }
}
