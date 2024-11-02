//
//  CoreDataManager.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ArticleDataModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}

// MARK: - Article
extension CoreDataManager {
    func saveArticle(_ article: Article) {
        let context = persistentContainer.viewContext
        let newArticle = ArticleModel(context: context)
        
        newArticle.title = article.title
        newArticle.articleDescription = article.description
        newArticle.author = article.author
        newArticle.imageURL = article.urlToImage
        newArticle.publishedAt = article.publishedAt
        
        do {
            try context.save()
            print("\(article.title ?? "") saved successfully.")
        } catch {
            print("Failed to save article: \(error)")
        }
    }
    
    func fetchFavoriteArticles() -> [Article] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
        
        do {
            let favoriteArticles = try context.fetch(fetchRequest)
            return favoriteArticles.map { entity in
                Article(
                    author: entity.author,
                    title: entity.title ?? "",
                    description: entity.articleDescription ?? "",
                    urlToImage: entity.imageURL,
                    publishedAt: entity.publishedAt ?? Date()
                )
            }
        } catch {
            print("Failed to fetch favorite articles: \(error)")
            return []
        }
    }
    
    func checkIfArticleExists(_ article: Article) -> Bool {
        let context = persistentContainer.viewContext
        
        guard let title = article.title else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to fetch article: \(error)")
            return false
        }
    }
}
