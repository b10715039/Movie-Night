//
//  DataGetter.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/4/20.
//

import Foundation
import CoreData
import UIKit

struct MovieData {
    var id: Int
    var nameEn: String
    var nameCh: String
    var date: String
    var score: Double
    var overview: String
    var posterPath: String
    var like: Bool
}

enum movieType {
    case Trend
    case New
    case Like
}
class DataManager {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "461042759acc9fa669a562cc1bcb8f6e"
    static let language = "zh-TW"
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
        var trendingMovies: [MovieData] = []
        let urlString = "\(baseURL)trending/movie/week?api_key=\(apiKey)&language=\(language)"
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string:urlString)!)
            let jsonDecoder = JSONDecoder()
            do {
                let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data)
                for movie in responseModel.results! {
                    trendingMovies.append(MovieData(id: movie.id!, nameEn: movie.original_title!, nameCh: movie.title!, date: movie.release_date!, score: movie.vote_average!, overview: movie.overview!, posterPath: movie.poster_path!, like: false))
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
        var trendingMovies: [MovieData] = []
        let urlString = "\(baseURL)movie/now_playing?api_key=\(apiKey)&language=\(language)"
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string:urlString)!)
            let jsonDecoder = JSONDecoder()
            do {
                let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data)
                for movie in responseModel.results! {
                    trendingMovies.append(MovieData(id: movie.id!, nameEn: movie.original_title!, nameCh: movie.title!, date: movie.release_date!, score: movie.vote_average!, overview: movie.overview!, posterPath: movie.poster_path!, like: false))
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
    
    static func storeMovieToDB(_ movie: MovieData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let movieDataDB = NSEntityDescription.insertNewObject(forEntityName: "MovieDataDB", into: managedContext) as! MovieDataDB
        movieDataDB.nameCh = movie.nameCh
        movieDataDB.nameEn = movie.nameEn
        movieDataDB.posterPath = movie.posterPath
        movieDataDB.id = Int32(movie.id)
        movieDataDB.score = movie.score
        movieDataDB.overview = movie.overview
        movieDataDB.date = movie.date
        movieDataDB.like = movie.like
        
        appDelegate.saveContext()
    }
    
    static func fetchStoredMovieDB() -> [MovieData] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var moviesData: [MovieData] = []

        do {
            let allMovies = try managedContext.fetch(MovieDataDB.fetchRequest())
            for movie in allMovies {
                moviesData.append(MovieData(id: Int(movie.id), nameEn: movie.nameEn ?? "Err", nameCh: movie.nameCh ?? "Err", date: movie.date ?? "Err", score: movie.score, overview: movie.overview ?? "Err", posterPath: movie.posterPath ?? "Err", like: movie.like))
            }
        } catch {
            print(error)
        }
        return moviesData
    }
    
    static func deleteAllStoredMovieDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let allMovies = try managedContext.fetch(MovieDataDB.fetchRequest())
            for movie in allMovies {
                managedContext.delete(movie)
            }
            appDelegate.saveContext()
            print("Delete all data.")
        } catch {
            print(error)
        }
    }
    
    static func deleteTargetStoredMovieDB(nameCh: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<MovieDataDB> = MovieDataDB.fetchRequest()
        let predicate = NSPredicate(format: "nameCh = '\(nameCh)'")
        fetchRequest.predicate = predicate
        do {
            let allMovies = try managedContext.fetch(fetchRequest)
            for movie in allMovies {
                managedContext.delete(movie)
            }
            appDelegate.saveContext()
            print("Delete: \(nameCh)")
        } catch {
            print(error)
        }
    }
}
