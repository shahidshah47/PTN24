//
//  PlayList.swift
//  CTV
//
//  Created by Sagar on 02/08/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import Foundation
import UIKit

struct PlayList {
    var id: String!
    var publishedAt: String!
    var channelId: String!
    var title: String!
    var description: String!
    var image: String!
    var channelTitle: String!
    var playlistId: String!
    var kind: String!
    var videoId: String!
    
    
    init(id: String, publishedAt: String, channelId: String, title: String, description: String, image: String, channelTitle: String, playlistId: String, kind: String, videoId: String) {
        self.id = id
        self.publishedAt = publishedAt
        self.channelId = channelId
        self.title = title
        self.description = description
        self.image = image
        self.channelTitle = channelTitle
        self.playlistId = playlistId
        self.kind = kind
        self.videoId = videoId
    }
}
