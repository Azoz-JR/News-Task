//
//  HomeViewController.swift
//  NewsTask
//
//  Created by Azoz Salah on 01/11/2024.
//

import Combine
import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var newsCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noResultsLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    var query: String = "Apple"
    
    let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                
        configureCollectionView()
        configureDatePicker()
        setupFavoritesObserver()
        
        bindViewModel()
        
        viewModel.fetchArticles(q: query, from: Date())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ArticleAddedToFavorites"), object: nil)
    }
    
    func configureCollectionView() {
        newsCollectionView.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.isScrollEnabled = true
    }
    
    func configureDatePicker() {
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(didChangedDate), for: .valueChanged)
    }
    
    @objc func didChangedDate() {
        let date = datePicker.date
        viewModel.fetchArticles(q: query, from: date)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func bindViewModel() {
        // MARK: Articles
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.newsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // MARK: Loading View
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
                
            }
            .store(in: &cancellables)
        
        // MARK: Error
        viewModel.$errorMessage
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
        
        // MARK: No Results Label
        viewModel.$noResultsFound
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noResultsFound in
                self?.noResultsLabel.isHidden = !noResultsFound
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Favorites
extension HomeViewController {
    @IBAction func didTappedFavouritesButton(_ sender: UIButton) {
        navigateToFavorites()
    }
    
    @objc func didAddToFavorites(_ notification: Notification) {
        guard let article = notification.userInfo?["article"] as? Article else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let alert = UIAlertController(title: article.title ?? "", message: "added to favourite successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupFavoritesObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didAddToFavorites),
            name: Notification.Name("ArticleAddedToFavorites"),
            object: nil
        )
    }
}
