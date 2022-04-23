//
//  MovieDetailViewController.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/21.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {

    var movieData: MovieData?
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var labelNameCh: UILabel!
    @IBOutlet weak var labelNameEn: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fileURL = URL(string: "https://image.tmdb.org/t/p/original/" + movieData!.posterPath)
        posterImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterImage.sd_setImage(with: fileURL)
        labelNameCh.text = movieData!.nameCh
        labelNameEn.text = movieData!.nameEn
        labelDate.text = movieData!.date
        labelScore.text = String(movieData!.score)
        labelOverview.text = movieData!.overview
        labelOverview.sizeToFit()
        
    }
    
    func setData(movieData: MovieData) {
        self.movieData = movieData
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
