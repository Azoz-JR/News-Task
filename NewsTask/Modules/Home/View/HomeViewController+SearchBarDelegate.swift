//
//  HomeViewController+SearchBarDelegate.swift
//  NewsTask
//
//  Created by Azoz Salah on 02/11/2024.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.fetchArticles(q: query, from: datePicker.date)
        self.query = query
    }
}
