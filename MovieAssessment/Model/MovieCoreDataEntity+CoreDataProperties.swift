//
//  MovieCoreDataEntity+CoreDataProperties.swift
//  MovieAssessment
//
//  Created by Xavier Toh on 31/10/24.
//
//

import Foundation
import CoreData


extension MovieCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreDataEntity> {
        return NSFetchRequest<MovieCoreDataEntity>(entityName: "MovieItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var year: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var searchterm: SearchTerm?

}

extension MovieCoreDataEntity : Identifiable {

}
