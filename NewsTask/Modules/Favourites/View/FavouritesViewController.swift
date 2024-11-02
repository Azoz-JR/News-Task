//
//  FavouritesViewController.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//

import UIKit

class FavouritesViewController: UIViewController {
    @IBOutlet var newsCollectionView: UICollectionView!
    
    var favouriteArticles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        favouriteArticles = CoreDataManager.shared.fetchFavoriteArticles()
        newsCollectionView.reloadData()
    }
    
    func configureCollectionView() {
        newsCollectionView.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
    }
}
