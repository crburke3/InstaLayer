//
//  CollectionView.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class PostCell:UICollectionViewCell{
    var imgLink:String!
    
    @IBOutlet var imageView: UIImageView!
    private var loaded = false
    
    override func layoutSubviews() {
        if !loaded{
            imageView.downloadWithHolder(_url: imgLink, _placeholder: UIImage(named: "Boost")!)
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCell
        cell.imgLink = collectionData[indexPath.row]
        return cell
    }
}
