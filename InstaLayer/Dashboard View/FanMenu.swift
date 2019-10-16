//
//  FanMenu.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/24/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import FanMenu
import UIKit

extension DashboardViewController{
    func initFanMenu(){
        fanMenu.menuBackground = .rgba(r: 255, g: 255, b: 255, a: 0.5)
        fanMenu.backgroundColor = UIColor.clear
        fanMenu.button = FanMenuButton(
            id: "main",
            image: UIImage(named: "+")!.resized(sizeChange: CGSize(width: 40, height: 40)),
            color: .rgba(r: 255, g: 255, b: 255, a: 0.3)
        )
        fanMenu.items = [
            FanMenuButton(
                id: "@",
                image: UIImage(named: "@")!.resized(sizeChange: CGSize(width: 40, height: 40)),
                color: .rgba(r: 209, g: 106, b: 190, a: 0.5),
                titlePosition: .left
            ),
            FanMenuButton(
                id: "#",
                image: UIImage(named: "hash")!.resized(sizeChange: CGSize(width: 40, height: 40)),
                color: .rgba(r: 63, g: 172, b: 245, a: 0.5),
                titlePosition: .bottom
            )
        ]
        
        fanMenu.onItemDidClick = { button in
            print("ItemDidClick: \(button.id)")
            switch button.id{
            case "#":
                self.goToSearch(targetType: .Hashtag)
            case "@":
                self.goToSearch(targetType: .User)
            default:
                break
            }
        }
        //fanMenu.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi/2.0))
    }
    
    func goToSearch(targetType:TargetType){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "search") as? SearchViewController {
            if let navigator = navigationController {
                viewController.searchType = targetType
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
}
