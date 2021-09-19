//
//  SingerDetailsTableViewCell.swift
//  Swift Practice # 81 JSON Second Meet
//
//  Created by Dogpa's MBAir M1 on 2021/9/19.
//

import UIKit

class SingerDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var singerNameLabl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
