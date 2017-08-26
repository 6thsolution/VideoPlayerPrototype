//
//  FullVideoPlayerVC.swift
//  VideoPlayerPrototype
//
//  Created by Mehdi Sohrabi (mehdok@gmail.com) on 8/26/17.
//  Copyright © 2017 SixthSolution. All rights reserved.
//

import UIKit

class FullVideoPlayerVC: UIViewController {

    //TODO or any other parameter
    var videoIndex: Int! = -1
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = String(format: "playing full video for index: %d", videoIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
