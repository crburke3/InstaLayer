//
//  DashboardViewController.swift
//  InstaLayer
//
//  Created by Christian Burke on 5/20/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import InfiniteCarouselCollectionView
import Charts
import UICircularProgressRing
import FanMenu
import CRRefresh

class DashboardViewController: BotKitViewController {

    @IBOutlet var collectionView: CarouselCollectionView!
    @IBOutlet var actionCircles: [UICircularProgressRing]!
    @IBOutlet var promoTable: UITableView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var screenHeight: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var fanMenu: FanMenu!
    @IBOutlet var profileImage: RoundImageView!
    @IBOutlet var backgroundImage: RoundImageView!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timespanLabel: UILabel!
    
    var charts:[LineChartView] = [LineChartView(), LineChartView()]
    let pageControl = UIPageControl()
    let followDataSet = LineChartDataSet(entries: [ChartDataEntry(x: 0, y: 0), ChartDataEntry(x: 5,y: 5), ChartDataEntry(x: 6,y: 6)], label: "Follows")
    let loader = LoadingView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        loader.isHidden = true
        masterBrowser.alpha = 0.0
        masterBrowser.restartTimer()
        scrollView.cr.addHeadRefresh {
            self.reloadUserData()
        }
        followersLabel.text = loadString(ident: SaveLocation.followers.rawValue)
        followingLabel.text = loadString(ident: SaveLocation.following.rawValue)
        initCarousel()
        loadCircles()
        initFanMenu()
        fanMenu.isHidden = true
        promoTable.delegate = self
        promoTable.dataSource = self
        promoTable.backgroundColor = UIColor.clear
        scrollView.cr.beginHeaderRefresh()
    }
    
    func reloadUserData(){
        fanMenu.isHidden = true
        masterBrowser.navigateTo(_url: "https://panel.instazood.com/dashboard", reload: true, endWait: 2.0) { (succ, msg) in
            masterBrowser.checkPopUps { (loaded) in
                masterBrowser.getHTML(html: { (html) in
                    masterBrowser.scraper = BotScraper(dashboardHTML: html!)
                    self.scrollView.cr.endHeaderRefresh()
                    if masterBrowser.scraper.stats.followers == 0 && masterBrowser.scraper.stats.following == 0{
                        self.showPopUp(_title: "Oops, Load Messed Up", _message: "please swipe down to refresh again")
                        return
                    }
                    self.fanMenu.isHidden = false
                    self.saveString(str: String(masterBrowser.scraper.stats.followers), location: SaveLocation.followers.rawValue)
                    self.saveString(str: String(masterBrowser.scraper.stats.following), location: SaveLocation.following.rawValue)
                    self.loadCircles()
                    self.loadHeader()
                    self.promoTable.reloadData()
                    self.timespanLabel.text = "\(masterBrowser.scraper.daysLeft) days left"
                })
            }
        }
    }
    
    func loadHeader(){
        let data = masterBrowser.scraper.stats
        profileImage.downloaded(from: data.profileImageLink)
        followersLabel.text = String(data.followers)
        followingLabel.text = String(data.following)
    }
    
    func loadCircles(){
        let stats = masterBrowser.scraper.stats
        for circle in actionCircles{
            var formatter = UICircularProgressRingFormatter()
            formatter.valueIndicator = ""
            circle.valueFormatter = formatter
            var val = CGFloat(0)
            switch circle.restorationIdentifier!{
            case "likes":
                val = CGFloat(stats.likes)
            case "follows":
                val = CGFloat(stats.follows)
            case "comments":
                val = CGFloat(stats.comments)
            default:
                break
            }
            circle.maxValue = val
            circle.value = val
            circle.startProgress(to: val, duration: 0.5)
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        masterBrowser.signOutUser()
        masterNav.popToRootViewController(animated: true)
        saveString(str: nil, location: .email)
        saveString(str: nil, location: .password)
    }
}
