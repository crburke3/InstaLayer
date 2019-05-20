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
    let barFrame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: 80)
    var label = UILabel()
    var backButton = UIButton()
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
        let toolbar = UIView(frame: barFrame)
        toolbar.backgroundColor = UIColor.marketplace.mainBlue
        backButton = UIButton(frame: CGRect(x: 23, y: 16.5, width: 54, height: 57))
        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.contentEdgeInsets.left = 10
        backButton.contentEdgeInsets.top = 15
        backButton.contentEdgeInsets.bottom = 15
        backButton.contentEdgeInsets.right = 30
        backButton.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        toolbar.addSubview(backButton)
        addSubview(toolbar)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.navigationController?.popViewController(animated: true, saveCount: true)
        }
    }
    
    override func layoutSubviews() {

    }
}


