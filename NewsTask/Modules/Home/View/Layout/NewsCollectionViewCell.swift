//
//  NewsCollectionViewCell.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cellContainerView: UIView!
    @IBOutlet var newsImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var authorContainer: UIView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var details: UILabel!
    
    static let identifier = "NewsCollectionViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainerView.backgroundColor = .white
        cellContainerView.layer.cornerRadius = 8
        
        newsImage.layer.cornerRadius = 8
        
        authorContainer.layer.cornerRadius = 13.25
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCollectionViewCell", bundle: nil)
    }
    
    func configureCell(article: Article) {
        newsTitle.text = article.title
        authorLabel.text = article.author
        details.text = article.description
        
        authorContainer.isHidden = article.author?.isEmpty ?? true
        
        if let imageUrlString = article.urlToImage, let imageURL = URL(string: imageUrlString) {
            loadImage(url: imageURL)
        } else {
            hideImageLoadingView()
            newsImage.image = UIImage(named: "imagePlaceholder")
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
                self.newsImage.image = image
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
}
