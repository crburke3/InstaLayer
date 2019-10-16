//
//  MonthlyViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 6/4/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import PopupDialog

class MonthlyViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var signUp:Bool!
    let loader = LoadingView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        loader.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @IBAction func purchase(_ sender: Any) {
        loader.isHidden = false
        SwiftyStoreKit.purchaseProduct(monthlyPoductId, atomically: true) { result in
            var err = ""
            switch result {
            case .success(let purchase):
                self.showPopUp2(_title: "Thank you for your purchase!", _message: "we wont let you down :)")
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: err = ("Unknown error. Please contact support")
                case .clientInvalid: err = ("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: err = ("The purchase identifier was invalid")
                case .paymentNotAllowed: err = ("The device is not allowed to make the payment")
                case .storeProductNotAvailable: err = ("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: err = ("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: err = ("Could not connect to the network")
                case .cloudServiceRevoked: err = ("User has revoked permission to use this cloud service")
                default: err = ((error as NSError).localizedDescription)
                }
                self.showPopUp(_title: "Error During Purchase", _message: err)
            }
            DispatchQueue.main.async {
                self.loader.isHidden = true
            }
        }
    }
    @IBAction func restore(_ sender: Any) {
        loader.isHidden = false
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            DispatchQueue.main.async {
                self.loader.isHidden = true
            }
            if results.restoreFailedPurchases.count > 0 {
                self.showPopUp(_title: "Restore Failed", _message: "\(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                self.showPopUp2(_title: "Restore Success", _message: "\(results.restoredPurchases)")
            }
            else {
                self.showPopUp(_title: "We Checked, But...", _message: "There was nothing to restore :(")
            }
        }
    }
    
    func verifySubscription(){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = monthlyPoductId
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    self.showPopUp2(_title: "You have already bought this!", _message: "we wont let you down :)")
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    //self.showPopUp(_title: "Your subscription is expired", _message: "please renew")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    //self.showPopUp(_title: "Thank you for your purchase!", _message: "we wont let you down :)")
                }
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func addHyperLink(){
        let fullText = " Privacy Policy & Terms and Conditions"
        let attributedString = NSMutableAttributedString(string: fullText)
        let url = URL(string: "https://www.emailmeform.com/builder/form/5Bx3ag9G94C51O1fn67")!
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, fullText.count - 0))
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
        attributedString.setAttributes(attributes, range: NSMakeRange(0, 1))
        self.textView.attributedText = attributedString
        self.textView.isUserInteractionEnabled = true
        self.textView.isEditable = false
        
        // Set how links should appear: blue and underlined
        self.textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    func goToNextVC(){
        if signUp{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUp") as? SignUpViewController {
                masterNav.pushViewController(viewController, animated: true)
            }
        }else{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountSignIn") as? AccountSignInViewController {
                masterNav.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func showPopUp2(_title:String, _message:String){
        let title = _title
        let message = _message
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "keep movin") {
            self.goToNextVC()
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }
}
