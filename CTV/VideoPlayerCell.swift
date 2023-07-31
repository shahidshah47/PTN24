//
//  VideoPlayerCell.swift
//  CTV
//
//  Created by bhavin on 28/07/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerCell: UITableViewCell {
    
    
    @IBOutlet weak var youtube_Player: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
