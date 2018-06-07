//
//  HKMusicTableViewCell.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/22.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit

class HKMusicTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var musicNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
