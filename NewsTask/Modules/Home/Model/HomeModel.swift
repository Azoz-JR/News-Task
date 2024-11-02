//
//  HomeModel.swift
//  NewsTask
//
//  Created by Azoz Salah on 01/11/2024.
//

import Foundation


// MARK: - NewsModel
struct NewsModel: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    
    init(source: Source? = nil, author: String?, title: String, description: String, url: String? = nil, urlToImage: String?, publishedAt: Date, content: String? = nil) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
