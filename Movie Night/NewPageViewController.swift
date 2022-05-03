//
//  NewPageViewController.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/23.
//

import UIKit
import SDWebImage
class NewPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var trendingMovies: [MovieData] = []
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let currentMovie = trendingMovies[indexPath.row]
        let posterUrl = currentMovie.posterPath
        let fileURL = URL(string: "https://image.tmdb.org/t/p/original/" + posterUrl)
        cell.posterImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.posterImage.sd_setImage(with: fileURL)
        cell.labelNameCh.text = currentMovie.nameCh
        cell.labelNameEn.text = currentMovie.nameEn
        cell.labelDate.text = currentMovie.date
        cell.labelScore.text = String(currentMovie.score)
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(handleLikes), for: .touchUpInside)
        var likeString = currentMovie.like ? "喜歡" : "沒有"
        cell.buttonLike.setTitle(likeString, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
        print("Movie: \(cell.labelNameCh.text)")
        
        let newVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        newVC.title = "電影細節"
        newVC.setData(movieData: trendingMovies[indexPath.row])
        show(newVC, sender: self)
    }
    
    @objc func handleLikes(sender: AnyObject) {
        print("LIKE!")
        trendingMovies[sender.tag].like = !trendingMovies[sender.tag].like
        reloadTableView(sender.tag)
    }
    func reloadTableView(_ row: Int = -1) {
        if row == -1 {
            myTableView.reloadData()
        } else {
            let indexRow = IndexPath(item: row, section: 0)
            myTableView.reloadRows(at: [indexRow], with: .fade)
        }
    }
    
    func pushDataToTable(_ movieData: [MovieData]) {
        trendingMovies.append(contentsOf: movieData)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Task.init {
            let data: [MovieData] = await DataManager.getMoviesByType(type: .New)
            pushDataToTable(data)
            reloadTableView()
        }
    }
}
