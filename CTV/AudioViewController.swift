//
//  AudioViewController.swift
//  PTN 24
//
//  Created by RIZWAN ULLAH on 15/05/2021.
//  Copyright © 2021 bhavin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire
import SwiftyJSON
import FTIndicator
import SDWebImage
import youtube_ios_player_helper
import PIPKit

var avpController = AVPlayerViewController()

class AudioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
                           AVPlayerViewControllerDelegate,AVPictureInPictureControllerDelegate {

         @IBOutlet weak var tbl_List: UITableView!
         @IBOutlet weak var placeholder_Image: UIImageView!
         
         var homepage_Data = [HomePageFolder]()

         @IBOutlet weak var btn_video: UIButton!
         @IBOutlet weak var upper_View: UIView!
         var player: AVPlayer!
         var avpController = AVPlayerViewController()
         var pipController: AVPictureInPictureController?
         var streamURL: URL? = nil

     //MARK:- viewDidLoad
         override func viewDidLoad() {
             super.viewDidLoad()
             // Do any additional setup after loading the view, typically from a nib.
             
             tbl_List.tableFooterView = UIView()
             
             //let liveUrl : URL = URL(string: "http://ptn24.com/ptn24/api/live")!
             //let stream:URL = URL(string: "https://cdn.samtv.ca:9443/ptv24/index.m3u8")!
             //let headers: [String: String] = ["Api-Key":"cNwT"]
             
             //let asset = AVURLAsset(url: liveUrl, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
             //let assetURl = AVAsset(url: stream)
             
             //let playerItem = AVPlayerItem(asset: assetURl)

             self.player = AVPlayer(playerItem: nil)
             self.avpController = AVPlayerViewController()
             self.avpController.removeFromParent()
             self.avpController.player = self.player
             
             //pip mode
         
             let layer = AVPlayerLayer.init(player: player);
             // Ensure PiP is supported by current device.
             if AVPictureInPictureController.isPictureInPictureSupported() {

                 print("PIP enabled")

                 // Create a new controller, passing the reference to the AVPlayerLayer.
                 pipController = AVPictureInPictureController(playerLayer: layer)
                 pipController?.delegate = self

                 _ = pipController?.observe(\AVPictureInPictureController.isPictureInPicturePossible,
                                                                             options: [.initial, .new]) { [weak self] _, change in
                     // Update the PiP button's enabled state.
                 }

                 self.avpController.allowsPictureInPicturePlayback = true

             } else {
                 // PiP isn't supported by the current device. Disable the PiP button.
                 print("PIP not supported")

             }
             
             avpController.allowsPictureInPicturePlayback = true
//            avpController.view.backgroundColor = .clear
             avpController.delegate = self
             
             avpController.player?.play()
             
             self.avpController.view.frame = upper_View.bounds
             
     //        self.present(avpController, animated: true, completion : nil)
             
             
             self.avpController.delegate = self
             
             //self.avpController.showsPlaybackControls = false
             
             self.avpController.view.frame = upper_View.bounds
     //        self.avpController.view.frame.size.height = upper_View.frame.height
             self.addChild(avpController)
             upper_View.addSubview(avpController.view)
             player.play()
//             placeholder_Image.isHidden = true
             
             
             get_Folder_From_API()
         }
         
         override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(true)
             
             player.play()
             
             NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
                 DispatchQueue.main.async {
                     self.player?.seek(to: CMTime.zero)
                     self.player?.play()
                 }
             })
         }
         
         override func viewDidDisappear(_ animated: Bool) {
             super.viewDidDisappear(true)
             
             self.avpController.player?.pause()
             
         }
         
         override func viewWillLayoutSubviews() {
             super.viewWillLayoutSubviews()
             
             
         }
         
         @IBAction func btn_More(_ sender: UIBarButtonItem) {
             let action = UIAlertController.init(title: "PTN 24", message: "", preferredStyle: .actionSheet)
             let share_App = UIAlertAction.init(title: "Share App", style: .default) { (action) in
                 // text to share
                 
                 // set up activity view controller
                 let activityViewController = UIActivityViewController(activityItems: [""], applicationActivities: nil)
                 activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                 
                 // exclude some activity types from the list (optional)
                 //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
                 
                 // present the view controller
                 self.present(activityViewController, animated: true, completion: nil)

             }
             let contact = UIAlertAction.init(title: "Connect With Us", style: .default) { (action) in
                 let popup = self.storyboard!.instantiateViewController(withIdentifier: "ShareView") as! ShareView
                 self.providesPresentationContextTransitionStyle = true
                 self.definesPresentationContext = true
                 popup.modalPresentationStyle = .overCurrentContext
                 self.present(popup, animated: true, completion: {  })
             }
             let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                 
             }
             action.addAction(share_App)
             action.addAction(contact)
             action.addAction(cancel)
             
             let barButtonItem = self.navigationItem.rightBarButtonItem!
             let buttonItemView = barButtonItem.value(forKey: "view")
             let buttonItemSize = (buttonItemView as AnyObject).frame
             
             action.popoverPresentationController?.sourceView = view
             action.popoverPresentationController?.sourceRect = buttonItemSize!
             
             self.present(action, animated: true, completion: nil)
             
         }
         
         @IBAction func btn_Video(_ sender: UIButton) {
             sender.isSelected = !sender.isSelected
             
             if sender.isSelected {
                 placeholder_Image.isHidden = false
             } else {
                 placeholder_Image.isHidden = true
             }
         }
         
         
         func get_Folder_From_API() {
             
             //player.replaceCurrentItem(with: AVPlayerItem(url: streamingURL))
             
             DispatchQueue.main.async {
                 //FTProgressIndicator.showProgressWithmessage("Loading...", userInteractionEnable: false)
             }
             
             let httpHeader: HTTPHeaders = ["Api-Key":"cNwT"]
             
             //fetch live stream url
             Alamofire.request(LIVE_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: httpHeader).responseJSON { (response) in
                 print(response.request!)
                 switch response.result {
                 case .success(let value):
                     let json = JSON(value)
                     print("JSON: \(json)")
                     
                     if json.dictionary != nil {
                         if let playlists = json["radio_url"].array {
                             if playlists.count > 0 {
                                 let item = playlists[0]
                                 let stream = item["url"].stringValue
                                 self.streamURL = URL(string: stream)!
                                 
                                 print("stream "+stream)
                                 
                                 if self.streamURL != nil {
                                     self.player.replaceCurrentItem(with: AVPlayerItem(url: self.streamURL!))
                                 }
                                 
                             }
                         }
                     }
                     
                     DispatchQueue.main.async {
                         FTProgressIndicator.dismiss()
                     }
                     
                     self.view.isUserInteractionEnabled = true
                 case .failure(let error):
                     print(error)
                     AlertShow.showAlert(title: "Error", message: "Something went wrong please try again later", in: self)
                     DispatchQueue.main.async {
                         FTProgressIndicator.dismiss()
                     }
                     self.view.isUserInteractionEnabled = true
                 }
             }
             
             
             //fetch playlist
             Alamofire.request(HOME_PAGE_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: httpHeader).responseJSON { (response) in
                 print(response.request!)
                 switch response.result {
                 case .success(let value):
                     let json = JSON(value)
                     //print("JSON: \(json)")
                     
                     if json.dictionary != nil {
                         if let playlists = json["yt_playlists"].array {
                             for playlist in playlists {
                                 let playlist_path = playlist["playlist_path"].stringValue
                                 let playlist_id = playlist["playlist_id"].stringValue
                                 let thumb = playlist["thumb"].stringValue
                                 let title = playlist["title"].stringValue
                                 let last_updated = playlist["last_updated"].stringValue
                                 let date_created = playlist["date_created"].stringValue
                                 
                                 self.homepage_Data.append(HomePageFolder(playlist_path: playlist_path, playlist_id: playlist_id, thumb: thumb, title: title, last_updated: last_updated, date_created: date_created))
                             }
                         }
                     }
                     self.tbl_List.reloadData()

                     DispatchQueue.main.async {
                         FTProgressIndicator.dismiss()
                     }
                     
                     self.view.isUserInteractionEnabled = true
                 case .failure(let error):
                     print(error)
                     AlertShow.showAlert(title: "Error", message: "Something went wrong please try again later", in: self)
                     DispatchQueue.main.async {
                         FTProgressIndicator.dismiss()
                     }
                     self.view.isUserInteractionEnabled = true
                 }
             }
         
             
         }
         
     //MARK:- TableView Methods
         
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return homepage_Data.count
         }
         
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoCell
             cell.img_View.sd_setImage(with: URL(string: homepage_Data[indexPath.row].thumb), placeholderImage: #imageLiteral(resourceName: "television_placeholder"))
             cell.lbl_Title.text = homepage_Data[indexPath.row].title
             cell.lbl_Updated_Date.text = homepage_Data[indexPath.row].last_updated
             cell.lbl_Created_Date.text = homepage_Data[indexPath.row].date_created
             return cell
         }
         
         func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
             let view = cell.contentView
             view.layer.opacity = 0.1
             UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                 view.layer.opacity = 1
             }, completion: nil)
         }
         
         func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 153.0
         }
         
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             performSegue(withIdentifier: "toPlayList", sender: self)
         }
             
     // MARK: - Navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if segue.identifier == "toPlayList" {
                 let indexPath = tbl_List.indexPathForSelectedRow!
                 let destination = segue.destination as? PlayListView
                 destination?.receive_PlayListId = homepage_Data[indexPath.row].playlist_id
             }
         }
         
     //MARK:-
         override func didReceiveMemoryWarning() {
             super.didReceiveMemoryWarning()
             // Dispose of any resources that can be recreated.
         }
         
         func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
                 
                 let currentviewController = navigationController?.visibleViewController
                 
     //            if currentviewController != playerViewController{
     //
     //                currentviewController?.present(playerViewController, animated: true, completion: nil)
     //
     //            }
                 
         }

     }
