//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Cynthia Wang on 8/29/18.
//  Copyright © 2018 Cynthia Wang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let controller = segue.destination as? NewsDetailViewController else {
                    print ("Error: Storyboard mis-configuration")
                    return
                }
                
                let article = DataManager.shared.filteredNews[indexPath.row]
                if let url = URL (string: article.urlString!){
                    controller.url = url
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let isClear = searchController.searchBar.text?.isEmpty, isClear == true {
            DataManager.shared.filteredNews.removeAll()
            tableView.reloadData()
        } else {
            activityIndicator.startAnimating()
            DataManager.shared.fetchFilteredNews(with:searchController.searchBar.text){ [weak self] in
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        let article = DataManager.shared.filteredNews[indexPath.row]
        
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.source?.name

        return cell
    }
}
