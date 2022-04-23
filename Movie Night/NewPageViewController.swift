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
    
    func reloadTableView() {
        myTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task.init {
            let data: [MovieData] = await DataGetter.getMoviesByType(type: .New)
            trendingMovies = data
            print("Await complete.")
            reloadTableView()
        }
        // Do any additional setup after loading the view.
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
