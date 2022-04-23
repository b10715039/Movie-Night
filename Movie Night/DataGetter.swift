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

enum movieType {
    case Trend
    case New
    case Like
}
class DataGetter {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "461042759acc9fa669a562cc1bcb8f6e"
    static let language = "zh-TW"
    static var trendingMovies: [MovieData] = []
    class func getTestData() -> String {
        return "Test"
    }
    static func getMoviesByType(type: movieType) async -> [MovieData] {
        var movieData: [MovieData] = []
        switch type {
        case .Trend:
            movieData = await getTrendMovies()
        case .New:
            movieData = await getNewMovies()
        case .Like:
            return []
        }
        return movieData
    }
    static func getTrendMovies() async -> [MovieData] {
        let urlString = "\(baseURL)trending/movie/week?api_key=\(apiKey)&language=\(language)"
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
    
    static func getNewMovies() async -> [MovieData] {
        let urlString = "\(baseURL)movie/now_playing?api_key=\(apiKey)&language=\(language)"
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
