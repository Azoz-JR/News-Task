//
//  DetailsViewController.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var authorContainer: UIView!
    @IBOutlet var articleDescription: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var authorLabel: UILabel!
        
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureArticle()
    }
    
    func configureView() {
        containerView.layer.cornerRadius = 24
        authorContainer.layer.cornerRadius = 24
        articleImage.layer.cornerRadius = 24
    }
    
    func configureArticle() {
        guard let article else {
            return
        }
        
        articleTitle.text = article.title
        articleDescription.text = article.description
        authorLabel.text = article.author
        if let imageUrlString = article.urlToImage, let imageURL = URL(string: imageUrlString) {
            loadImage(url: imageURL)
        } else {
            hideImageLoadingView()
            articleImage.image = UIImage(named: "imagePlaceholder")
        }
        
        authorContainer.isHidden = article.author?.isEmpty ?? true
    }

    @IBAction func didTappedAddToFavourite(_ sender: UIButton) {
        if let article {
            addToFavourites(article)
            
            NotificationCenter.default.post(
                name: Notification.Name("ArticleAddedToFavorites"),
                object: nil,
                userInfo: ["article": article]
            )
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func loadImage(url: URL) {
        showImageLoadingView()
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            self?.hideImageLoadingView()
            
            guard let self else { return }
            
            guard let data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.articleImage.image = image
            }
        }.resume()
    }
    
    private func showImageLoadingView() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideImageLoadingView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func addToFavourites(_ article: Article) {
        guard !CoreDataManager.shared.checkIfArticleExists(article) else {
            showAlert()
            return
        }
        
        CoreDataManager.shared.saveArticle(article)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Duplicate Article",
            message: "This article is already in your favorites.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
