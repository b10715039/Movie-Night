//
//  DataGetter.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/20.
//

import Foundation

struct MovieData {
    var id: Int
    var nameEn: String
    var nameCh: String
    var date: String
    var score: Double
    var overview: String
    var posterPath: String
}
class DataGetter {
    static let apiKey = "461042759acc9fa669a562cc1bcb8f6e"
    static var trendingMovies: [MovieData] = [MovieData(id: 123456, nameEn: "test", nameCh: "QAQ", date: "123", score: 8.3, overview: "asdad", posterPath: "test")]
    class func getTestData() -> String {
        return "Test"
    }
    
    static func getJson() async {
        print("Getting json")
        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=461042759acc9fa669a562cc1bcb8f6e&language=zh-TW"
        
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) {(data, res, err) in
            guard let data = data else {
                print("ELSE")
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data)
                for movie in responseModel.results! {
                    trendingMovies.append(MovieData(id: movie.id!, nameEn: movie.original_title!, nameCh: movie.title!, date: movie.release_date!, score: movie.vote_average!, overview: movie.overview!, posterPath: movie.poster_path!))
                }
                print("There is \(trendingMovies.count) movies.")
            } catch {
                
            }
            
        }
        task.resume()
    }
    
    static func getJsonTrend() async -> [MovieData] {
        print("Getting json")
        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=461042759acc9fa669a562cc1bcb8f6e&language=zh-TW"
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string:urlString)!)
            let jsonDecoder = JSONDecoder()
            do {
                let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data)
                for movie in responseModel.results! {
                    trendingMovies.append(MovieData(id: movie.id!, nameEn: movie.original_title!, nameCh: movie.title!, date: movie.release_date!, score: movie.vote_average!, overview: movie.overview!, posterPath: movie.poster_path!))
                }
                return trendingMovies
            } catch {
                return []
            }
        } catch {
            return []
        }
    }

    static func getDataFromServer() {
        
    }
}
