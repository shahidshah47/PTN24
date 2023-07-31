//
//  Modal.swift
//  CTV
//
//  Created by bhavin on 28/07/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import Foundation
import UIKit

struct HomePageFolder {
    var playlist_path: String!
    var playlist_id: String!
    var thumb: String!
    var title: String!
    var last_updated: String!
    var date_created: String!
    
    init(playlist_path: String, playlist_id: String, thumb: String, title: String, last_updated: String, date_created: String) {
        self.playlist_path = playlist_path
        self.playlist_id = playlist_id
        self.thumb = thumb
        self.title = title
        self.last_updated = last_updated
        self.date_created = date_created
    }

}
