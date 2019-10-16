//
//  SignUpViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/19/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpViewController: BotKitViewController, UIGestureRecognizerDelegate {

    @IBOutlet var botView: BotKit!
    @IBOutlet var botHeight: NSLayoutConstraint!
    @IBOutlet var headerBlock: UIView!
    @IBOutlet var nameField: SkyFloatingLabelTextField!
    @IBOutlet var emailField: SkyFloatingLabelTextField!
    @IBOutlet var passwordField: SkyFloatingLabelTextField!
    
    let loader = LoadingView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        masterBrowser.alpha = 0.1
        loader.isHidden = true
        loader.label.text = "Creating Account..."
        headerBlock.alpha = 0
        botView.alpha = 0
        botView.scrollView.isScrollEnabled = false
        masterBrowser.navigateTo(_url: "https://panel.instazood.com/signup", timeout: 10, reload: false, endWait: 0, completion: nil)
    }
    
    @objc func viewTap() {
        UIView.animate(withDuration: 0.25, delay: 1, animations: {
            self.headerBlock.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseOut], animations: {
            self.botHeight.constant = 490
            self.view.layoutIfNeeded()
        })
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

    @IBAction func submit(_ sender: Any) {
        if !goodName()  || !goodEmail() || !goodPassword(){
            return
        }
        loader.isHidden = false
        botView.clearCookies()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTap) )
        tapGesture.delegate = self
        botView.addGestureRecognizer(tapGesture)
        //botView.SignUpUser(fullName:"Bob dean", email: "heythere\(10)@gmail.com", password: "1234567") { (succ, msg) in
        botView.SignUpUser(fullName: nameField.text!, email: emailField.text!, password: passwordField.text!) { (succ, msg) in
            DispatchQueue.main.async {
                if succ{
                    if msg.contains(find: "recaptcha_wait"){
                        self.loader.isHidden = true
                        self.headerBlock.alpha = 1
                        UIView.animate(withDuration: 0.5, animations: {
                            self.botView.alpha = 1
                            self.botHeight.constant = 140
                        })
                    }
                    if msg.contains(find: "recaptcha_finished"){
                        UIView.animate(withDuration: 0.25, animations: {
                            self.botView.alpha = 0
                            self.botHeight.constant = 0
                        })
                        self.loader.isHidden = false
                    }
                    if msg.contains(find: "sign_up_finished"){
                        masterBrowser = self.botView
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountSetup") as? LinkViewController {
                            masterNav.pushViewController(viewController, animated: true)
                        }
                    }
                }else{
                    self.loader.isHidden = true
                    self.showPopUp(_title: "Error during account creation", _message: msg)
                    //print("ERROR: \(msg)")
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
    
}
