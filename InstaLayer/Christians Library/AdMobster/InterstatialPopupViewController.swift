//
//  AdViewController.swift
//  FlexForum
//
//  Created by Christian Burke on 4/29/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class InterstatialPopupViewController: UIViewController, GADInterstitialDelegate{
    var popup:GADInterstitial!
    var AdID:String
    var nextVC:UIViewController?
    
    init(interstiatialAd:GADInterstitial, _AdID:String) {
        self.AdID = _AdID
        self.popup = interstiatialAd
        super.init(nibName: nil, bundle: nil)
        popup.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.FlexForum.flexRed
        if popup.isReady{
            self.popup.present(fromRootViewController: self)
        }else{
            //setupPopUp()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupPopUp(){
        popup = GADInterstitial(adUnitID: self.AdID)
        popup.delegate = self
        popup.load(GADRequest())
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.setupPopUp()
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        self.setupPopUp()
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: false, saveCount: false)
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        self.setupPopUp()
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        //self.navigationController?.popViewController(animated: false, saveCount: false)
        if nextVC != nil{
            masterNav!.pushViewController(nextVC!, animated: false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        self.setupPopUp()
        print("interstitialWillLeaveApplication")
    }
}
