//
//  VideoMTableViewCell.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import UIKit

class VideoMTableViewCell: UITableViewCell
{
    @IBOutlet weak var lbl_video_name: UILabel!
    @IBOutlet weak var lbl_video_type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
