//
//  ViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/19/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class LoginViewController: UIViewController {
    
    let groupSecret = "8ad4af9a081947cfb899e36acf83707c"
    let subscriptionID = "FullMonthlyAccess"
    
    let loader = LoadingView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.label.text = "Checking Subscription..."
        view.addSubview(loader)
        waitForSubscription()
        
        masterNav = self.navigationController!
        if let savedPwd = loadString(ident: .password){
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountSignIn") as? AccountSignInViewController {
                masterNav.pushViewController(viewController, animated: false)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if isPurchased == .paid{
            goToSignUp()
        }
        else{
            goToPaywall(signUp: true)
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        if isPurchased == .paid{
            goToSignIn()
        }
        else{
            goToPaywall(signUp: false)
        }
    }
    
    
    func goToPaywall(signUp:Bool){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "monthlySub") as? MonthlyViewController {
            viewController.signUp = signUp
            masterNav.pushViewController(viewController, animated: true)
        }
    }
    
    func goToSignUp(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUp") as? SignUpViewController {
            masterNav.pushViewController(viewController, animated: true)
        }
    }
    
    func goToSignIn(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountSignIn") as? AccountSignInViewController {
            masterNav.pushViewController(viewController, animated: true)
        }
    }
    
    func waitForSubscription(){
        let timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
            if isPurchased != .loading{
                self.loader.isHidden = true
                timer.invalidate()
            }
        })
    }
}
