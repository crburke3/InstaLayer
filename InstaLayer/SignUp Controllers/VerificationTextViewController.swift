//
//  VerificationTextViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/21/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension LinkViewController {
    
    func loadOptions(options:[String]){
        verifCodesView.isHidden = false
        switch options.count{
        case 3:
            btn3.isHidden = false
            btn1.setTitle(String(options[2]), for: .normal)
            btn2.isHidden = false
            btn2.setTitle(String(options[1]), for: .normal)
            btn1.isHidden = false
            btn1.setTitle(String(options[0]), for: .normal)
            break
        case 2:
            btn2.isHidden = false
            btn2.setTitle(String(options[1]), for: .normal)
            btn1.isHidden = false
            btn1.setTitle(String(options[0]), for: .normal)
            break
        case 1:
            btn1.isHidden = false
            btn1.setTitle(String(options[0]), for: .normal)
            break
        default:
            break
        }
    }
    
}
