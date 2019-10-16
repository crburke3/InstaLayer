//
//  TextHandler.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/20/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension SignUpViewController{
    
    func addTextTargets(){
        nameField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidEnd(_ textfield: UITextField) {
        
    }
    
    func goodName()->Bool{
        if nameField.text!.count < 3{
            nameField.errorMessage = "Something looks off, try making it longer"
            return false
        }
        nameField.errorMessage = ""
        return true
    }
    
    func goodEmail()->Bool{
        if !emailField.text!.contains(find: "@") || emailField.text!.count < 3 || !emailField.text!.contains(find: "."){
            emailField.errorMessage = "Something looks off, try making it longer"
            return false
        }
        emailField.errorMessage = ""
        return true
    }
    
    func goodPassword()->Bool{
        if passwordField.text!.count < 5{
            passwordField.errorMessage = "Something looks off, try making it longer"
            return false
        }
        passwordField.errorMessage = ""
        return true
    }
}
