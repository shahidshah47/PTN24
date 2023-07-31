//
//  YouTubePlayerView.swift
//  CTV
//
//  Created by bhavin on 02/08/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import UIKit
import FTIndicator
import youtube_ios_player_helper

class YouTubePlayerView: UIViewController, YTPlayerViewDelegate {
    
    var receive_VideoID = ""
    var receive_PlaylistId = ""
    var receive_Video_Array = [String]()
    var getIndex = 0
    var total_Videos = 1
    var play_Video_Index = 0
    
    
    let dict = ["modestbranding" : 0,"controls" : 1 ,"autoplay" : 1,"playsinline" : 1,"autohide" : 1,"showinfo" : 0, "origin" : "http://www.youtube.com"] as [String : Any]
    
    @IBOutlet weak var yt_Player: YTPlayerView!
    
//MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("receive_PlaylistId:",receive_PlaylistId);
        print("getIndex:",getIndex)
        print("receive_Video_Array:",receive_Video_Array)
        
        if getIndex != 0 {
            receive_Video_Array = Array(receive_Video_Array).shiftRight(amount: getIndex)
            //swap(&receive_Video_Array[getIndex], &receive_Video_Array[0])
            print("receive_Video_Array_Swapped:",receive_Video_Array)
        }
        
        total_Videos = receive_Video_Array.count-1
        
        print("total_Videos:",total_Videos)
        
        //
        self.yt_Player.delegate = self
        //FTProgressIndicator.showProgressWithmessage("Loading...", userInteractionEnable: false)
        self.yt_Player.load(withVideoId: receive_VideoID, playerVars: dict) 
    }
    
//MARK:- Youtube Player Delegate Method
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("playerViewDidBecomeReady")
        FTProgressIndicator.dismiss()
        self.yt_Player.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            play_Video_Index += 1
            play_NextVideo()
            print("Video Ended")
        }
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("Error:-",error)
    }
    
    func play_NextVideo() {
        if play_Video_Index <= total_Videos {
            print("play_Video_Index:",play_Video_Index)
            print(receive_Video_Array[play_Video_Index])
            self.yt_Player.load(withVideoId: receive_Video_Array[play_Video_Index], playerVars: dict)
        }
    }
    
//MARK:-
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
