//
//  HomeVC.swift
//  VideoPlayerPrototype
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 8/26/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

protocol FullVideoPlayerDelegate: class {
    func getVideoindex() -> Int
}

class HomeVC: UITableViewController {
    var topView: TopView!
    var topController: UIRefreshControl!
    
    weak var delegate: FullVideoPlayerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTopView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "story_vc") {
            let storyVC = segue.destination as! VideoStoryVC
            self.delegate = storyVC
        } else if (segue.identifier == "full_video_vc") {
            if (delegate != nil) {
                let fullPalyer = segue.destination as! FullVideoPlayerVC
                fullPalyer.videoIndex = delegate?.getVideoindex()
            }
        }
    }
}

extension HomeVC {
    func addTopView() {
        topController = UIRefreshControl()
        topController.backgroundColor = .clear
        topController.tintColor = .clear
        topController.addTarget(self, action: #selector(showFullVideo(_:)), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(topController)
        
        let view = Bundle.main.loadNibNamed("TopView", owner: self, options: nil)?[0] as! UIView
        view.frame = topController.bounds
        topView = view as! TopView
        
        
        topController.addSubview(topView)
    }
    
    func showFullVideo(_ refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.performSegue(withIdentifier: "full_video_vc", sender: nil)
        }
    }
}
