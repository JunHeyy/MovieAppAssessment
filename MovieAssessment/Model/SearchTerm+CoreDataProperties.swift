//
//  SearchTerm+CoreDataProperties.swift
//  MovieAssessment
//
//  Created by Xavier Toh on 31/10/24.
//
//

import Foundation
import CoreData


extension SearchTerm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchTerm> {
        return NSFetchRequest<SearchTerm>(entityName: "SearchTerm")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var term: String?
    @NSManaged public var movieitem: NSSet?

}

// MARK: Generated accessors for movieitem
extension SearchTerm {

    @objc(addMovieitemObject:)
    @NSManaged public func addToMovieitem(_ value: MovieCoreDataEntity)

    @objc(removeMovieitemObject:)
    @NSManaged public func removeFromMovieitem(_ value: MovieCoreDataEntity)

    @objc(addMovieitem:)
    @NSManaged public func addToMovieitem(_ values: NSSet)

    @objc(removeMovieitem:)
    @NSManaged public func removeFromMovieitem(_ values: NSSet)

}

extension SearchTerm : Identifiable {

}
