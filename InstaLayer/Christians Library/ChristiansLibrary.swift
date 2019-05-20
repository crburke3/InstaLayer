//
//  ChristiansLibrary.swift
//  MarketPlaceMedium
//
//  Created by Christian Burke on 2/6/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Kingfisher
import PopupDialog

extension MKPlacemark{
    func parseAddress() -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (self.subThoroughfare != nil && self.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (self.subThoroughfare != nil || self.thoroughfare != nil) && (self.subAdministrativeArea != nil || self.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (self.subAdministrativeArea != nil && self.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            self.subThoroughfare ?? "",
            firstSpace,
            // street name
            self.thoroughfare ?? "",
            comma,
            // city
            self.locality ?? "",
            secondSpace,
            // state
            self.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension UITableViewCell{
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension UIImage{
    func resized(sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension UIImageView {
    
    func downloaded(from url: URL) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        for view in self.superview!.subviews{
            if(view is UIActivityIndicatorView){
                let spinner: UIActivityIndicatorView = view as! UIActivityIndicatorView
                spinner.startAnimating()
            }
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    if let safeImage = UIImage(named: "Qmark"){
                        DispatchQueue.main.async {
                            self.image = safeImage
                        }
                    }
                    return
                    }
            DispatchQueue.main.async() {
                if(self.superview != nil){
                    for view in self.superview!.subviews{
                        if(view is UIActivityIndicatorView){
                            let spinner: UIActivityIndicatorView = view as! UIActivityIndicatorView
                            spinner.stopAnimating()
                        }
                    }
                }
                self.image = image
            }
            }.resume()
    }
    
    func downloaded(from link: String) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
    

    func downloadWithHolder(_url:String, _placeholder:UIImage){
        if let realURL = URL(string: _url){
            kf.setImage(with: realURL, placeholder: _placeholder, options: nil, progressBlock: nil) { (image, error, cacheType, imageUrl) in
                if error == nil{
                    self.stopSpinner()
                }else if error != nil{
                    self.stopSpinner()
                }
            }
        }
    }
    
    private func stopSpinner(){
        if(self.superview != nil){
            for view in self.superview!.subviews{
                if(view is UIActivityIndicatorView){
                    let spinner: UIActivityIndicatorView = view as! UIActivityIndicatorView
                    spinner.stopAnimating()
                }
            }
        }
    }
    
}


extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

class roundLabel:UILabel{
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var underlineWidth: Int = 0 {
        didSet{
            if let textString = self.text {
                let attributedString = NSMutableAttributedString(string: textString)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: underlineWidth, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
            }
        }
    }
}

class RoundView:UIView{
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
}

class BorderTextView:UITextView{
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}

@IBDesignable class RoundButton: UIButton{
    
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var underline: Bool = false {
        didSet{
            
            let attrs = [
                //NSAttributedString.Key.font : titleLabel?.font,
                //NSAttributedString.Key.foregroundColor : UIColor.red,
                NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            
            let attributedString = NSMutableAttributedString(string:"")
            let buttonTitleStr = NSMutableAttributedString(string:(self.titleLabel?.text)!, attributes:attrs)
            attributedString.append(buttonTitleStr)
            setAttributedTitle(attributedString, for: .normal)
        }
    }
}

@IBDesignable class RoundImageView: UIImageView{
    
    @IBInspectable var cornerRadius: Int = 0 {
        didSet{
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: Int = 0 {
        didSet{
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}


extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

extension MKMapView{
    func centerMapOnLocation(location: CLLocation, regionRadius:Double = 500.0) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.setRegion(coordinateRegion, animated: true)
    }

}

extension UINavigationController{
    func popToViewController(_identifier:String){
        for controller in self.viewControllers as Array {
            if let restoreID = controller.restorationIdentifier{
                if restoreID.contains(find: _identifier){
                    self.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
}

extension UIColor{
    struct marketplace {
        static var mainBlue: UIColor  { return UIColor(red: 122/255, green: 163/255, blue: 1, alpha: 1) }
        static var errorRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 84/255, alpha: 1) }
    }
    
    struct FlexForum{
        static var backgroundGrey: UIColor  { return UIColor(red: 48/255, green: 56/255, blue: 66/255, alpha: 1) }
        static var flexRed: UIColor  { return UIColor(red: 216/255, green: 112/255, blue: 53/255, alpha: 1) }
        static var errorRed: UIColor  { return UIColor(red: 255/255, green: 76/255, blue: 84/255, alpha: 1) }
        static var navOrange: UIColor  { return UIColor(red: 232/255, green: 121/255, blue: 58/255, alpha: 1) }
    }
}

extension UIViewController{
    func showPopUp(_title:String, _message:String){
        let title = _title
        let message = _message
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "okay") {
            print("You canceled the car dialog.")
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                        if let complete = onCompletion { complete() }
        }
        )
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                        self.isHidden = true
                        if let complete = onCompletion { complete() }
        }
        )
    }
    
}


extension UISearchBar{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}
