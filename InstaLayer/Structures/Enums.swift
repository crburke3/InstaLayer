//
//  BotClasses.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/19/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class BotKitViewController: UIViewController{

    override func viewDidLoad() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        masterBrowser.frame = UIScreen.main.bounds
        masterBrowser.alpha = 0.1
        self.view.addSubview(masterBrowser)
        self.view.sendSubviewToBack(masterBrowser)
        super.viewDidLoad()
    }
}

enum WebIdentity:String{
    case Id
    case Class
}

enum ActionType:Int{
    case click
    case innerText
    case src
    case doubleClick
    case value
    case width
    case innerHTML
    case style
}


enum TargetType:String{
    case User
    case Location
    case Hashtag
}

enum SaveLocation:String{
    case followers
    case following
    case username
    case instaPassword
}

enum SubType{
    case loading
    case paid
    case unpaid
}
