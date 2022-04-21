//
//  MovieTableViewCell.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/20.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var labelNameCh: UILabel!
    @IBOutlet weak var labelNameEn: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
