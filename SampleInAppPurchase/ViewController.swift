//
//  ViewController.swift
//  SampleInAppPurchase
//
//  Created by amarron on 2015/07/29.
//  Copyright (c) 2015年 amarron. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - SKProductsRequestDelegate
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("productsRequest")
        // Check whether there is an invalid item
        if response.invalidProductIdentifiers.count > 0 {
            let alertController = UIAlertController(title: "Error", message: "Item ID is invalid", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title:  "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        // Purchase process start
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        for product in response.products {
            let payment:SKPayment = SKPayment(product: product )
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("paymentQueue")
        
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchasing:
                print("Purchasing...")
            case SKPaymentTransactionState.Purchased:
                print("Purchased")
                // TODO: The items purchased processing (an upgraded version of the function restriction release processing, etc.)
                // TODO: record the purchase information
                let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "enable_rocket_car")
                defaults.synchronize()
                queue.finishTransaction(transaction)
            case SKPaymentTransactionState.Failed:
                print("Failed")
            case SKPaymentTransactionState.Restored:
                print("Restored")
                // TODO: The items purchased processing (an upgraded version of the function restriction release processing, etc.)
                queue.finishTransaction(transaction)
            default:
                print("default")
                queue.finishTransaction(transaction )
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print("Restore failed.")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("Restore Completed")
    }
    // MARK: - IBAction
    @IBAction func buy(sender: AnyObject) {
        // Check whether the billing can be
        if !SKPaymentQueue.canMakePayments() {
            let alertController = UIAlertController(title: "Error", message: "Can not Purchase", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // TODO: Set ProductID
        let set:NSSet = NSSet(object: "com.companyname.application.productid")
        let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: set as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
        
    }
    
    
    @IBAction func useCar(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        if NSUserDefaults.standardUserDefaults().boolForKey("enable_rocket_car") {
            alertController.message = "Use the rocket car"
        } else {
            alertController.message = "Use the normal car"
        }
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}

