//
//  ViewController.swift
//  SampleInAppPurchase
//
//  Created by okuri on 2015/07/29.
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
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("productsRequest")
        // 無効なアイテムがないかチェック
        if response.invalidProductIdentifiers.count > 0 {
            let alertController = UIAlertController(title: "エラー", message: "アイテムIDが不正です！", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title:  "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        // 購入処理開始
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        for product in response.products {
            let payment:SKPayment = SKPayment(product: product as! SKProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("paymentQueue")
        
        for transaction in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case SKPaymentTransactionState.Purchasing:
                    println("Purchasing...")
                case SKPaymentTransactionState.Purchased:
                    println("Purchased")
                    // TODO: アイテム購入した処理（アップグレード版の機能制限解除処理等）
                    // TODO: 購入の持続的な記録
                    let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "enable_rocket_car")
                    defaults.synchronize()
                    queue.finishTransaction(trans)
                case SKPaymentTransactionState.Failed:
                    println("Failed")
                case SKPaymentTransactionState.Restored:
                    println("Restored")
                    // TODO: アイテム購入した処理（アップグレード版の機能制限解除処理等）
                    queue.finishTransaction(trans)
                default:
                    println("default")
                    queue.finishTransaction(transaction as! SKPaymentTransaction)
                }
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
        println("Restore failed.")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        println("Restore Completed")
    }
    // MARK: - IBAction
    @IBAction func buy(sender: AnyObject) {
        // 課金が出来るかチェック
        if !SKPaymentQueue.canMakePayments() {
            let alertController = UIAlertController(title: "エラー", message: "課金できません！", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // TODO: ProductIDを変更
        let set:NSSet = NSSet(object: "com.companyname.application.productid")
        let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: set as Set<NSObject>)
        productsRequest.delegate = self
        productsRequest.start()
        
    }
    
    
    @IBAction func useCar(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        if NSUserDefaults.standardUserDefaults().boolForKey("enable_rocket_car") {
            alertController.message = "ロケットカーを使用"
        } else {
            alertController.message = "普通の自動車を使用"
        }
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}

