//
//  VideoStoryVC.swift
//  VideoPlayerPrototype
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 8/26/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import Haneke

class VideoStoryVC: UIPageViewController {
    var currentIndex: Int! = 0
    
    let videos = ["https://cl.ly/0Y0Y0p2O1R1W/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h01m26s-00h01m31s).mp4",
                   "https://cl.ly/1F2z3k3W2A3i/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m08s-00h00m15s).mp4",
                   "https://cl.ly/1M3r2d1Y1M2J/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m15s-00h00m21s).mp4",
                   "https://cl.ly/3z3K1X0l3b3Z/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m21s-00h00m27s).mp4",
                   "https://cl.ly/2Y3y3L0H3i1c/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m27s-00h00m37s).mp4",
                   "https://cl.ly/2G401O13420i/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m37s-00h00m46s).mp4",
                   "https://cl.ly/1H1X0W0T3n11/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m46s-00h00m55s).mp4",
                   "https://cl.ly/2D000G0U1q2z/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h00m55s-00h01m01s).mp4",
                   "https://cl.ly/1I2P3v1D082w/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h01m01s-00h01m09s).mp4",
                   "https://cl.ly/322B1g2G0g2r/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h01m09s-00h01m16s).mp4",
                   "https://cl.ly/2z1m3X0Z051p/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h01m16s-00h01m25s).mp4",
                   "https://cl.ly/370Z011K0L1j/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h01m31s-00h01m41s).mp4",
                   "https://cl.ly/363q052D3k43/download/Styx%20Shards%20Of%20Darkness%20Death%20Scenes(00h01m41s-00h01m48s).mp4"]
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCachingVideo()

        self.dataSource = self
        self.delegate = self
        
        startStoryPlayer(index: currentIndex)
    }
    
    func startStoryPlayer(index: Int) {
        let initialViewController = getViewControllerAtIndex(index: index)
        
        self.setViewControllers([initialViewController!],
                                direction: .forward,
                                animated: false,
                                completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getViewControllerAtIndex(index: Int) -> StoryPlayerVC! {
        let view = StoryPlayerVC(nibName: "StoryPlayerVC", bundle: nil)
        view.videoIndex = index
        view.videoUrl = videos[index]
        view.delegate = self
        
        return view
    }
}

extension VideoStoryVC: FullVideoPlayerDelegate {
    func getVideoindex() -> Int {
        return currentIndex
    }
}

extension VideoStoryVC: UIPageViewControllerDelegate {
    
}

extension VideoStoryVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentIndex = (viewController as! StoryPlayerVC).videoIndex + 1
        if currentIndex >= videos.count {
            currentIndex = videos.count - 1
        }
        
        return getViewControllerAtIndex(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentIndex = (viewController as! StoryPlayerVC).videoIndex - 1
        if currentIndex < 0 {
            currentIndex = 0
        }
        
        return getViewControllerAtIndex(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            currentIndex = (pageViewController.viewControllers!.first as! StoryPlayerVC).videoIndex
        }
    }
}

extension VideoStoryVC {
    func startCachingVideo() {
        let cache = Shared.dataCache
        
        for video in videos {
            cache.fetch(key: video).onFailure({ (error) in
                // video does not exist, get it from network
                
                _ = cache.fetch(URL: URL(string: video)!)
            })
        }
    }
}

extension VideoStoryVC: StoryPlayerDelegate {
    func playNextVideo(currentindex: Int) {
        self.currentIndex = currentindex + 1
        if self.currentIndex >= videos.count {
            self.currentIndex = videos.count - 1
            return
        }
        
        startStoryPlayer(index: currentIndex)
    }
}

