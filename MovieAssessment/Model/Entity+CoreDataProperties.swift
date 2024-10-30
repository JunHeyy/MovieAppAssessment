//
//  Entity+CoreDataProperties.swift
//  MovieAssessment
//
//  Created by Xavier Toh on 30/10/24.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var year: String?

}

extension Entity : Identifiable {

}
