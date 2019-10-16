//
//  SearchViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/24/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SHSearchBar
import PopupDialog

class SearchViewController: BotKitViewController, SHSearchBarDelegate {
    
    @IBOutlet var searchFrame: UIView!
    @IBOutlet var profImage: RoundImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var posts: UILabel!
    @IBOutlet var followers: UILabel!
    @IBOutlet var following: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var loaderFrame: UIView!
    @IBOutlet var addTargetButton: RoundButton!
    @IBOutlet var instaInfoView: RoundView!
    @IBOutlet var emptyLabel: UILabel!
    
    var searchBar: SHSearchBar!
    var searchType: TargetType!
    var viewConstraints: [NSLayoutConstraint]?
    var rasterSize: CGFloat = 11.0
    var collectionData:[String] = []
    let loader = LoadingView()
    var lastSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masterBrowser.alpha = 0
        view.addSubview(loader)
        view.bringSubviewToFront(addTargetButton)
        loader.alpha = 0
        initSearchbar()
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        masterBrowser.stopTimer()
        let targetButton = "promo-manage-button add-promo-modal__button-open btn btn-primary btn-md btn-md-autosize"
        masterBrowser.getElementByClass(_className: targetButton, _action: .click, completion: nil)

    }
    
    override func viewWillLayoutSubviews() {
        loader.frame = loaderFrame.frame
        super.viewWillLayoutSubviews()
    }
    
    func searchBarDidEndEditing(_ searchBar: SHSearchBar) {
        if searchBar.text!.count <= 2 || searchBar.text!.contains(find: lastSearch){
            return
        }
        loader.alpha = 1
        emptyLabel.isHidden = true
        masterBrowser.searchUser(username: searchBar.text!) { (succ, data) in
            self.instaInfoView.isHidden = false
            self.profImage.downloadWithHolder(_url: data.profPic, _placeholder: UIImage(named: "Boost")!)
            self.loader.alpha = 0
            self.name.text = data.name
            self.username.text = searchBar.text!
            self.posts.text = String(data.posts)
            self.followers.text = String(data.followers)
            self.following.text = String(data.following)
            self.collectionData = data.postArr
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func addTarget(_ sender: Any) {
        masterBrowser.alpha = 1
        //loader.alpha = 1
        loader.label.text = "Adding target: @\(searchBar.text!)"
        masterBrowser.addTarget(type: .User, name: searchBar.text!, completion: { (succ, msg) in
            masterBrowser.alpha = 1
            //self.loader.alpha = 0
            if succ{
                self.showSearchPopup(_title: "Successfully added Target: @\(self.searchBar.text!)", _message: "please refresh your home page")
            }else{
                self.showSearchPopup(_title: "Failed adding Target", _message: msg)
            }
        })
    }
    
    func showSearchPopup(_title:String, _message:String){
        let title = _title
        let message = _message
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "okay") {
        }
        
        let buttonTwo = CancelButton(title: "go to main") {
            self.navigationController!.popViewController(animated: true)
        }
        
        popup.addButtons([buttonTwo, buttonOne])
        
        self.present(popup, animated: true, completion: nil)
    }
}
    

