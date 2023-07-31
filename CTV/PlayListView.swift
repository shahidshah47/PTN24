//
//  PlayListView.swift
//  CTV
//
//  Created by Sagar on 02/08/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import FTIndicator

class PlayListView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var coll_Out: UICollectionView!
    
    var receive_PlayListId = ""
    var playlist = [PlayList]()
    
    
//MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "PTN 24"
        
        get_PlayList()
    }
    
//MARK:- Button More
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
    

//MARK:- Get PlayList
    func get_PlayList() {
        DispatchQueue.main.async {
            //FTProgressIndicator.showProgressWithmessage("Loading...", userInteractionEnable: false)
        }
        
        let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&pageToken&playlistId=\(self.receive_PlayListId)&maxResults=50&key=AIzaSyCFN3MkcPCAW6H2G6XBorINgyyt-R0zjN4"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.request!)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                if let items = json["items"].array {
                    for item in items {
                        let id = item["id"].stringValue
                        var publishedAt = ""
                        var channelId = ""
                        var title = ""
                        var description = ""
                        var image = ""
                        var channelTitle = ""
                        var playlistId = ""
                        var kind = ""
                        var videoId = ""
                        
                        
                        //Snippet
                        if let data = item["snippet"].dictionary {
                            publishedAt = (data["publishedAt"]?.stringValue)!
                            channelId = (data["channelId"]?.stringValue)!
                            title = (data["title"]?.stringValue)!
                            description = (data["description"]?.stringValue)!
                            channelTitle = (data["channelTitle"]?.stringValue)!
                            playlistId = (data["playlistId"]?.stringValue)!
                            
                            //Image
                            if let thumb = data["thumbnails"]?.dictionary {
                                if let resolution = thumb["high"]?.dictionary {
                                    image = (resolution["url"]?.stringValue)!
                                }
                            }
                            
                            //Resource Id
                            if let resolution = data["resourceId"]?.dictionary {
                                kind = (resolution["kind"]?.stringValue)!
                                videoId = (resolution["videoId"]?.stringValue)!
                            }
                        }
                        self.title = channelTitle
                        self.playlist.append(PlayList(id: id, publishedAt: publishedAt, channelId: channelId, title: title, description: description, image: image, channelTitle: channelTitle, playlistId: playlistId, kind: kind, videoId: videoId))
                    }
                }
                
                self.coll_Out.reloadData()
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
    
//MARK:- UICollectionView Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaylistCell
        cell.img_Display.sd_setImage(with: URL(string:playlist[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "television_placeholder"))
        cell.lbl_Title.text = playlist[indexPath.row].title
        if playlist[indexPath.row].publishedAt.count >= 10 {
            let date = playlist[indexPath.row].publishedAt.prefix(10)
            cell.lbl_Published.text = String(date)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.5,0.5,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPlayer", sender: self)
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayer" {
            let indexPath = coll_Out.indexPathsForSelectedItems
            let destination = segue.destination as? YouTubePlayerView
            destination?.receive_VideoID = playlist[(indexPath?[0].row)!].videoId
            destination?.receive_PlaylistId = playlist[(indexPath?[0].row)!].playlistId
            destination?.getIndex = (indexPath?[0].row)!
            destination?.receive_Video_Array = playlist.map({ ($0.videoId) })
        }
    }
    
//MARK:-
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
