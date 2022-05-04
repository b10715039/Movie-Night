//
//  TrendingPageViewController.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/20.
//

import UIKit
import SDWebImage

class TrendingPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [MovieData] = []
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let currentMovie = movies[indexPath.row]
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
        let likeImageName = currentMovie.like ? "heart-liked" : "heart"
        cell.buttonLike.setBackgroundImage(UIImage(named: likeImageName), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
        print("Movie: \(cell.labelNameCh.text)")
        
        let newVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetailViewController
        newVC.title = "電影細節"
        newVC.setData(movieData: movies[indexPath.row])
        show(newVC, sender: self)
    }
    
    @objc func handleLikes(sender: AnyObject) {
        print("LIKE!")
        movies[sender.tag].like = !movies[sender.tag].like
        if movies[sender.tag].like {
            DataManager.storeMovieToDB(movies[sender.tag])
        }
        else {
            DataManager.deleteTargetStoredMovieDB(nameCh: movies[sender.tag].nameCh)
        }
        let tMovies = DataManager.fetchStoredMovieDB()
        for tMovie in tMovies {
            print(tMovie.nameCh)
        }
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
        movies.append(contentsOf: movieData)
    }
    
    func removeAllTable() {
        movies.removeAll()
    }
    
    func setLikeInDB() {
        for (index, movie) in movies.enumerated() {
            if DataManager.findMovieInDB(movie.nameCh) {
                movies[index].like = true
            } else {
                movies[index].like = false
            }
        }
        reloadTableView()
    }
    override func viewDidLoad() {
        //DataManager.deleteAllStoredMovieDB()
        super.viewDidLoad()
        Task.init {
            let data: [MovieData] = await DataManager.getMoviesByType(type: .Trend)
            pushDataToTable(data)
            reloadTableView()
            setLikeInDB()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLikeInDB()
    }
}
