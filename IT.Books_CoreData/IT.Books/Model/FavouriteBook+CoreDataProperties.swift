//
//  FavouriteBook+CoreDataProperties.swift
//  IT.Books
//
//  Created by Philip on 10.09.21.
//
//

import Foundation
import CoreData


extension FavouriteBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteBook> {
        return NSFetchRequest<FavouriteBook>(entityName: "FavouriteBook")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var isbn13: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var url: String?

}

extension FavouriteBook : Identifiable {

}
