//
//  VideoSplashViewController.swift
//  VideoSplash
//
//  Created by paprika on 2017/9/20.
//  Copyright © 2017年 paprika. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

public enum ScalingMode{

    case Resize
    case ResizeAspect
    case ResizeAspectFill

}

public class VideoSplashViewController: UIViewController {

    private let moviePlayer = AVPlayerViewController()
    private var moviePlayerSoundLevel : Float = 1.0
    public var contentURL:NSURL = NSURL(){
    
        didSet{
        
            setMoviePlayer(url:contentURL)
        
        }
    }
    public var videoFrame:CGRect = CGRect()
    public var startTime:CGFloat = 0.0
    public var duration :CGFloat = 0.0
    public var backgroundColor : UIColor = UIColor.black{
    
        didSet{
        
            //ViewDidLoad里的代码可以在didSet里完成
            view.backgroundColor = backgroundColor
        }
    
    }
    public var sound : Bool = true{
    
        didSet{
        
            if sound {
                moviePlayerSoundLevel = 1.0
            }else{
            
                moviePlayerSoundLevel = 0.0
            }
        }
    
    }
    
    public var alpha : CGFloat = CGFloat(){
    
            didSet{
            
                moviePlayer.view.alpha = alpha
            }
    }

    public var alwaysRepeat:Bool = true{
    
        didSet{
        
            if alwaysRepeat {
                NotificationCenter.default.addObserver(self, selector: #selector(VideoSplashViewController.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: moviePlayer.player?.currentItem)
            }
        
        }
    
    }
    
    public var fillMode:ScalingMode = .ResizeAspectFill{
    
        didSet{
        
            switch fillMode {
            case .Resize:
                moviePlayer.videoGravity = AVLayerVideoGravityResize
            case .ResizeAspect:
                moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
            case .ResizeAspectFill:
                moviePlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            }
        }
    
    }
    
    func playerItemDidReachEnd(){
    
        //从头一帧继续重新播放
        moviePlayer.player?.seek(to: kCMTimeZero)
        moviePlayer.player?.play()
    }
    private func setMoviePlayer(url:NSURL){
    
        let videoCutter = VideoCutter()
        videoCutter.cropVideoWithUrl(videoUrl: url, startTime: startTime, duration: duration) { (videoPath, error)->Void in
            if let path = videoPath as NSURL?{
                
                self.moviePlayer.player = AVPlayer(url: path as URL)
                self.moviePlayer.player?.play()
                self.moviePlayer.player?.volume = self.moviePlayerSoundLevel
            }
        }
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        
        moviePlayer.view.frame = videoFrame
        moviePlayer.showsPlaybackControls = false
        view.addSubview(moviePlayer.view)
        view.sendSubview(toBack: moviePlayer.view)
        
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

    }

}
