//
//  StoryPlayerVC.swift
//  VideoPlayerPrototype
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 8/26/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit
import Haneke
import AVKit
import AVFoundation

protocol StoryPlayerDelegate: class {
    func playNextVideo(currentindex: Int)
}

class StoryPlayerVC: UIViewController {
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    var videoIndex : Int! = 0
    var videoUrl: String!
    var player: AVPlayer? = nil
    
    weak var delegate: StoryPlayerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addPlaybackObserver()
        
        showProgress(true)
        
        if player != nil {
            // player exist, resume playback
            player?.seek(to: kCMTimeZero)
            player?.play()
            
            return
        }
        
        let cache = Shared.dataCache
        
        cache.fetch(key: videoUrl)
            .onSuccess { (data) in
                // video exist in cache, play it
                
                // get file path from disk cache
                let (_, _, diskCache) = cache.formats[HanekeGlobals.Cache.OriginalFormatName]!
                let filePath = diskCache.path(forKey: self.videoUrl)
                
                self.playVideoWithUrl(URL(fileURLWithPath: filePath))
            }
            .onFailure { (error) in
                self.playVideoWithUrl(URL(string: self.videoUrl)!)
            }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removePlaybackObserver()
        
        if player != nil {
            player?.pause()
        }
    }
    
    deinit {
        player?.removeObserver(self, forKeyPath: "status")
    }
}

extension StoryPlayerVC {
    func playVideoWithUrl(_ url: URL) {
        player = AVPlayer(url: url)
        
        player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.frame = self.view.bounds
//        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        player?.play()
    }
    
    func playNextVideo() {
        if delegate != nil {
            delegate?.playNextVideo(currentindex: videoIndex)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (player?.isEqual(object))! && keyPath == "status" {
            if player?.status == AVPlayerStatus.readyToPlay {
                print("readyToPlay")
                showProgress(false)
            } else if(player?.status == AVPlayerStatus.failed) {
                print("failed")
            }
        }
    }
    
    
}

extension StoryPlayerVC {
    func addPlaybackObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playNextVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    func removePlaybackObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showProgress(_ show: Bool) {
        progress.isHidden = !show

        if show == true {
            progress.startAnimating()
        } else {
            progress.stopAnimating()
        }
    }
}
