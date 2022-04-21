//
//  TrendingPageViewController.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/20.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

}
class TrendingPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        cell.posterImage.load(url: fileURL!)
        cell.labelNameCh.text = currentMovie.nameCh
        return cell
    }
    
    func reloadTableView() {
        myTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task.init {
            let data: [MovieData] = await DataGetter.getJsonTrend()
            trendingMovies = data
            print("Await complete.")
            reloadTableView()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func testButton(_ sender: Any) {
        print("Test")
        reloadTableView()
        print(DataGetter.trendingMovies.count)
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
