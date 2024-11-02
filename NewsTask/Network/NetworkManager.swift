//
//  NetworkManager.swift
//  NewsTask
//
//  Created by Azoz Salah on 01/11/2024.
//

import Combine
import Foundation

class NetworkManager {
    private let baseUrl = "https://newsapi.org/v2/everything"
    
    func fetchArticles(q: String, from: Date) -> AnyPublisher<[Article],Error> {
        let formattedDate = from.formattedDate
        
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "from", value: formattedDate),
            URLQueryItem(name: "apiKey", value: Constants.apiKey)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NewsModel.self, decoder: decoder)
            .map({ $0.articles })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
