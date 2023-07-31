//
//  VideoCell.swift
//  CTV
//
//  Created by bhavin on 28/07/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Updated_Date: UILabel!
    @IBOutlet weak var lbl_Created_Date: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
