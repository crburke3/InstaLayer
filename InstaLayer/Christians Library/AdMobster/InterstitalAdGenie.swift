//
//  BannerAd.swift
//  FlexForum
//
//  Created by Christian Burke on 4/29/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

////----------------------------------------AD MANAGEMENT ------------------------------------------------------------------------------
////-------------------------------------------------------------------------------------------------------------------------------------
//// CHANGE THE AdID AND IT SHOULD WORK GREAT. ALSO GOTTA CHANGE THE info.plist
//let interstatial = InterstitalAdGenie(tester: false, navTrigger: 2, AdID:"ca-app-pub-5001099037052237/1943582694")
//// Interstital PARAMETERS
//// - Test = automatically use the Testing ad ID
//// - navTrigger = the number of navigations that happen before presenting the Ad
//
//let banner = BannerAdGenie(test: false, viewcontrollerIDs: ["main", "post"], height: 50, AdID:"ca-app-pub-5001099037052237/1855597560")
//// BANNER PARAMETERS
//// - Test = automatically use the Testing ad ID
//// - viewcontrollerIDs = the restorationIDs that are on the storyboard viewcontrollers
//// - Height = Obiously the height
////-------------------------------------------------------------------------------------------------------------------------------------
//var masterAccounts:[String] = []
//var masterNav:UINavigationController?

class InterstitalAdGenie{
    public static let AppID = "ca-app-pub-5001099037052237~1580744327"
    public var InterstatialAdID:String
    public var NavigationTrigger:Int
    private var currInterstialID:String
    var interstitial: GADInterstitial!
    private var popupVC: InterstatialPopupViewController!
    var navCount = 0

    init(tester:Bool = false, navTrigger:Int, AdID:String){
        self.InterstatialAdID = AdID
        self.currInterstialID = AdID
        self.NavigationTrigger = navTrigger
        if tester{
            self.currInterstialID = "ca-app-pub-3940256099942544/4411468910"
        }
        interstitial = GADInterstitial(adUnitID: currInterstialID)
        self.popupVC = InterstatialPopupViewController(interstiatialAd: self.interstitial, _AdID: self.currInterstialID)
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func ShowPopUp(nextVC:UIViewController?){
        self.popupVC.nextVC = nextVC
        if popupVC.popup.isReady{
            UIApplication.getTopMostViewController()!.present(self.popupVC, animated: true, completion: nil)
        }else{
            print("Ad was not loaded durring attempt")
        }
    }
    
    func incrementNavCount(nextVC:UIViewController?){
        navCount += 1
        if navCount >= NavigationTrigger{
            self.ShowPopUp(nextVC: nextVC)
            navCount = 0
        }else{
            if nextVC != nil{
                let topVC = UIApplication.getTopMostViewController()!
                topVC.navigationController?.pushViewController(nextVC!, animated: true)
            }
        }
    }
}

extension UINavigationController{
    
    func pushViewController(viewController: UIViewController, animated:Bool = true, saveCount:Bool){
        if saveCount{
            interstatial.incrementNavCount(nextVC: viewController)
        }else{
            self.pushViewController(viewController, animated: animated)
        }
        if let vcID = viewController.restorationIdentifier{
            let inIDs = banner.vcIDs.filter{ $0.contains(find: vcID)}
            if inIDs.count > 0{
                //Then the next VC needs a damn banner on it
                viewController.view.addSubview(banner)
            }
        }
    }
    
    func popViewController(animated:Bool, saveCount:Bool){
        self.popViewController(animated: animated)
        if saveCount{
            interstatial.incrementNavCount(nextVC: nil)
        }
        let viewController = UIApplication.getTopMostViewController()!
        if let vcID = viewController.restorationIdentifier{
            let inIDs = banner.vcIDs.filter{ $0.contains(find: vcID)}
            if inIDs.count > 0{
                //Then the next VC needs a damn banner on it
                for view in viewController.view.subviews{
                    if banner == view{
                        banner.removeFromSuperview()
                    }
                }
                viewController.view.addSubview(banner)
                banner.layoutSubviews()
            }
        }
    }
}
