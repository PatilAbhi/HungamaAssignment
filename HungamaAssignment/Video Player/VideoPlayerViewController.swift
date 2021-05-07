//
//  VideoPlayerViewController.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate
{

    @IBOutlet weak var ytPlayer: YTPlayerView!
    var getURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ytPlayer.delegate = self
        
        print(getURL)
        
        ytPlayer.load(withVideoId: getURL, playerVars: ["playsinline": 1])
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView)
    {
        ytPlayer.playVideo()
    }
}
