//
//  BannderAdGenie.swift
//  FlexForum
//
//  Created by Christian Burke on 4/29/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class BannerAdGenie: UIView, GADBannerViewDelegate{
    public static let AppID = "ca-app-pub-5001099037052237~1580744327"
    public var RealBannerAdID:String
    public static let TestBannerID = "ca-app-pub-3940256099942544/2934735716"
    var vcIDs:[String]
    private var bannerView = GADBannerView()
    private var currAdID:String
    var bannerHeight:CGFloat
    
    init(test:Bool = false, viewcontrollerIDs:[String], height:CGFloat = 60, floorOffset:CGFloat = 0, AdID:String) {
        self.bannerHeight = height
        self.RealBannerAdID = AdID
        self.currAdID = RealBannerAdID
        self.vcIDs = viewcontrollerIDs
        super.init(frame: CGRect.zero)
        if test{
            currAdID = BannerAdGenie.TestBannerID
        }
        self.backgroundColor = UIColor.clear
        let screenSize: CGRect = UIScreen.main.bounds
        let realFrame = CGRect(x: 0, y: screenSize.height - (floorOffset + height), width: screenSize.width, height: height)
        self.frame = realFrame
        bannerView.adUnitID = currAdID
        bannerView.delegate = self
    }
    
    func setupAds(){
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Testing value
        bannerView.frame = self.frame
        let topVC = UIApplication.getTopMostViewController()!
        if banner.superview != topVC{
            topVC.view.addSubview(bannerView)
            topVC.view.bringSubviewToFront(bannerView)
        }
        bannerView.rootViewController = UIApplication.getTopMostViewController()!
        bannerView.load(GADRequest())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        showAdBar()
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("CLICKED")
    }

    
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func showAdBar(animate:Bool = true){
        if animate{
            UIView.animate(withDuration: 1) {
                self.bannerView.isHidden = false
            }
        }else{
            self.bannerView.isHidden = false
        }
    }
    
    func hideAdBar(animate:Bool = true){
        if animate{
            UIView.animate(withDuration: 1) {
                self.isHidden = true
            }
        }else{
            self.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAds()
        //let topVC = UIApplication.getTopMostViewController()!
//        if let parent = topVC.view{
//            for view in parent.subviews{
//                let yPos = view.frame.origin.y
//                let height = view.frame.height
//                if (yPos + height >= UIScreen.main.bounds.height - self.frame.height){
//                    if (view == self || view == bannerView){
//                        continue
//                    }
//                    for const in view.constraints{
//                        print(const)
//                    }
//                    view.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: 0)
//                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height - bannerView.frame.height)
//                }
//            }
//        }
    }
}
