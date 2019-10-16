//
//  CarouselView.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/22/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import InfiniteCarouselCollectionView
import Charts



extension DashboardViewController: CarouselCollectionViewDataSource{
    
    func initCarousel(){
        //view.addSubview(collectionView)
        //view.addSubview(pageControl)
        //pageControl.numberOfPages = charts.count
        //pageControl.tintColor = .black
        
        collectionView.register(CVCell.self, forCellWithReuseIdentifier:"id")
        collectionView.reloadData()
        collectionView.carouselDataSource = self
        collectionView.isAutoscrollEnabled = true
        collectionView.autoscrollTimeInterval = 6.0
        let size = collectionView.frame.size
        collectionView.flowLayout.itemSize = CGSize(width: size.width, height: size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        pageControl.frame.origin.y = view.bounds.maxY - 80 - pageControl.frame.height
        pageControl.sizeToFit()
    }
    
    var numberOfItems: Int {
        return charts.count
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: fakeIndexPath) as! CVCell
        cell.dataSet = followDataSet
        //cell.backgroundColor = colors[index]
        return cell
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didSelectItemAt index: Int) {
        print("Did select item at \(index)")
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
    }
    
}
