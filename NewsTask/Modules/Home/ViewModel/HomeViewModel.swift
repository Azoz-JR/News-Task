//
//  HomeViewModel.swift
//  NewsTask
//
//  Created by Azoz Salah on 01/11/2024.
//

import Combine
import Foundation

class HomeViewModel {
    @Published var articles: [Article] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var noResultsFound: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = NetworkManager()
    
    func fetchArticles(q: String, from: Date) {
        isLoading = true
        
        networkManager.fetchArticles(q: q, from: from)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                    self?.articles = []
                    self?.noResultsFound = true
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles.filter({ $0.title != "[Removed]" })
                self?.noResultsFound = articles.isEmpty
            }
            .store(in: &cancellables)

    }
    
    private func handleError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError {
            case URLError(.badURL):
                errorMessage = "The URL is invalid. Please check and try again."
            default:
                break
            }
        } else {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
