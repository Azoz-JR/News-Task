//
//  UIViewController.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//

import UIKit

extension UIViewController {
    func navigateToArticleDetails(article: Article) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.article = article
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func navigateToFavorites() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouritesViewController = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        
        self.navigationController?.pushViewController(favouritesViewController, animated: true)
    }
}
