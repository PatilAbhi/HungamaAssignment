//
//  NowPlayingMovieListTableViewCell.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import UIKit

class NowPlayingMovieListTableViewCell: UITableViewCell
{

    @IBOutlet weak var img_backgroundPoster: DesignCustomImages!
    @IBOutlet weak var img_movie_poster: DesignCustomImages!
    @IBOutlet weak var lbl_movie_name: UILabel!
    @IBOutlet weak var lbl_release_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
