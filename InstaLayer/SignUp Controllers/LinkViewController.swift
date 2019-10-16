//
//  AccountSetupViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/20/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyStoreKit

class LinkViewController: BotKitViewController {

    @IBOutlet var username: SkyFloatingLabelTextField!
    @IBOutlet var password: SkyFloatingLabelTextField!
    @IBOutlet var verificationField: SkyFloatingLabelTextField!
    @IBOutlet var btn1: RoundButton!
    @IBOutlet var btn2: RoundButton!
    @IBOutlet var btn3: RoundButton!
    @IBOutlet var verifCodesView: UIView!
    
    let loader = LoadingView(frame: UIScreen.main.bounds)
    var isVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        masterBrowser.frame = UIScreen.main.bounds
        view.addSubview(masterBrowser)
        view.sendSubviewToBack(masterBrowser)
        masterBrowser.alpha = 0.1
        loader.isHidden = true
        if let loadedUsername = loadString(ident: SaveLocation.username.rawValue){
            username.text = loadedUsername
        }
        if let loadedPwd = loadString(ident: SaveLocation.instaPassword.rawValue){
            password.text = loadedPwd
        }
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        verificationField.isHidden = false
        let title = (sender as! UIButton).titleLabel?.text!
        print(title)
        //masterBrowser.addToView(frame: UIScreen.main.bounds)
        if title!.contains(find: "Text"){
            masterBrowser.getElementById(id: "challenge-verify-by-sms", _action: .click) { (succ, msg) in
            }
        }
        else if title!.contains(find: "Email"){
            masterBrowser.getElementById(id: "challenge-verify-by-email", _action: .click) { (succ, msg) in
            }
        }
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        masterBrowser.textFieldEnter(_type: .Id, name: "security_code", text: verificationField.text!, completion: { (entered) in
            masterBrowser.getElementByClass(_className: "fa fa-arrow-right", _action: .click, completion: { (succ, msg) in
                if succ{
                    print("FINSIHED FUCKING LINKING")
                }
            })
        })
    }
    

    @IBAction func linkAccount(_ sender: Any) {
        loader.isHidden = false
        saveString(str: username.text!, location: SaveLocation.username.rawValue)
        saveString(str: password.text!, location: SaveLocation.instaPassword.rawValue)
        masterBrowser.linkInstagramAccount(_username: self.username.text!, password: self.password.text!) { (succ, msg2) in
            print(msg2)
            if succ{
                switch msg2{
                case "CLICKED_LINK_ACCOUNT":
                    self.updateLabel(text: "1")
                    break
                    
                case "CLICKED_NEXT_BUTTON":
                    self.updateLabel(text: "2")
                    break
                    
                case "ENTERING_INFO":
                    self.updateLabel(text: "3")
                    break
                    
                case "LINKING_ACCOUNT":
                    self.updateLabel(text: "Linking account...")
                    break
                    
                case "VERIFICATION_CODE":
                    masterBrowser.checkForSMS(options: { (foundOptions) in
                        self.loader.isHidden = true
                        self.loadOptions(options: foundOptions)
                    })
                    break
                    
                case "FINISHED":
                    self.updateLabel(text: "Done!")
                    sleep(1)
                    DispatchQueue.main.async {self.loader.isHidden = true}
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dashboard") as? DashboardViewController {
                        if let navigator = masterNav {
                            navigator.pushViewController(viewController, animated: true)
                        }
                    }
                    break
                    
                default:
                    if msg2.contains(find: "-"){
                        //print the proressbar percentage
                        self.updateLabel(text: "Linking account...\(msg2.split(separator: "-")[0])%")
                    }
                }
            }else{
                if msg2.contains("FAILED:"){
                    var message = msg2.split(separator: ":")
                    var realMessage = "No error message"
                    if message.count >= 2{
                        realMessage = String(message[1])
                    }
                    self.showPopUp(_title: "Failed Login", _message: realMessage + "\nthis process can sometimes take ~10 attempts")
                }
                DispatchQueue.main.async {
                    self.loader.isHidden = true
                }
            }
        }
    }
    
    func updateLabel(text:String){
        DispatchQueue.main.async {
            self.loader.label.text = text
        }
    }
    
    func subscription(){
        SwiftyStoreKit.purchaseProduct(monthlyPoductId, atomically: true) { result in
            self.loader.alpha = 0
            switch result{
            case .success(let product):
                // Deliver content from server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                let appleValidator = AppleReceiptValidator(service: .production)
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    if case .success(let receipt) = result {
                        let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: monthlyPoductId, inReceipt: receipt)
                        
                        switch purchaseResult {
                        case .purchased(let expiryDate):
                            print("Product is valid until \(expiryDate)")
                        case .expired(let expiryDate):
                            print("Product is expired since \(expiryDate)")
                        case .notPurchased:
                            print("This product has never been purchased")
                        }
                        
                    } else {
                        // receipt verification error
                    }
                }
                
            // purchase error
            case .error(let error):
                var err = ""
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
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        masterBrowser.signOutUser()
        masterNav.popToRootViewController(animated: true)
    }
    
}

