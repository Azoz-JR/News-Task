//
//  ArticleModel+CoreDataProperties.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//
//

import Foundation
import CoreData


extension ArticleModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleModel> {
        return NSFetchRequest<ArticleModel>(entityName: "ArticleModel")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var title: String?

}

extension ArticleModel : Identifiable {

}
