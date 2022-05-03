//
//  MovieDataDB+CoreDataProperties.swift
//  Movie Night
//
//  Created by 凃佑瑋 on 2022/5/3.
//
//

import Foundation
import CoreData


extension MovieDataDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDataDB> {
        return NSFetchRequest<MovieDataDB>(entityName: "MovieDataDB")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: Int32
    @NSManaged public var like: Bool
    @NSManaged public var nameCh: String?
    @NSManaged public var nameEn: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var score: Double

}

extension MovieDataDB : Identifiable {

}
