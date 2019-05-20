//
//  EasyNavBar.swift
//  MarketPlaceMedium
//
//  Created by Christian Burke on 2/28/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class ChristiansNavigationBar: UIView{
    let screenFrame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let spinner = UIActivityIndicatorView()
    var label = roundLabel()
    var backButton = RoundButton()
    var labelHeight:CGFloat = 30
    var labelWidth:CGFloat = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        let screenSize = UIScreen.main.bounds
        self.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: screenSize.width, height: screenSize.height)
        backgroundColor = UIColor(red: 162/255, green: 163/255, blue: 1, alpha: 0.7)
        spinner.frame.origin = CGPoint(x: screenFrame.midX, y: screenFrame.midY)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        
        label = roundLabel(frame: CGRect(x: UIScreen.main.bounds.midX - CGFloat(labelWidth/2), y: UIScreen.main.bounds.midY - 50, width: labelWidth, height: labelHeight))
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.cornerRadius = 5
        label.numberOfLines = 0
        label.textAlignment = .center
        //label.backgroundColor = UIColor.white
        
        let btnHeight = CGFloat(25)
        let btnWidth = CGFloat(labelWidth)
        backButton = RoundButton(frame: CGRect(x: UIScreen.main.bounds.midX - CGFloat(btnWidth/2), y: UIScreen.main.bounds.midY - CGFloat((btnHeight/2) - 100), width: btnWidth, height: btnHeight))
        backButton.setTitle("head back", for: .normal)
        backButton.backgroundColor = UIColor.black
        backButton.cornerRadius = 5
        backButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.addSubview(label)
        //self.addSubview(backButton)
        self.addSubview(spinner)
    }
    
    func displayBackButton(_show:Bool){
        if(_show){
            self.addSubview(backButton)
        }else{
            backButton.removeFromSuperview()
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.navigationController?.popViewController(animated: true)
        }
    }
    
    override func layoutSubviews() {
        spinner.removeFromSuperview()
        spinner.frame.origin = CGPoint(x: screenFrame.midX, y: screenFrame.midY)
        self.addSubview(spinner)
    }
}

//let screenSize = UIScreen.main.bounds
//let screenWidth = screenSize.width
//let screenHeight = screenSize.height + 50
//let toolbar = UIView(frame: CGRect(x: screenSize.origin.x, y: screenSize.origin.y, width: screenWidth, height: 80))
//toolbar.backgroundColor = UIColor.marketplace.mainBlue
//let backButton = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
//backButton.backgroundColor = UIColor.black
//backButton.addTarget(self, action: #selector(backClick), for: UIControl.Event.touchUpInside)
//toolbar.addSubview(backButton)
//view.addSubview(toolbar)
