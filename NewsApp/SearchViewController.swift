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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let controller = segue.destination as? NewsDetailViewController else {
                    print ("Error: Storyboard mis-configuration")
                    return
                }
                
                let article = DataManager.shared.searchedNews[indexPath.row]
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
        
        DataManager.shared.fetchFilteredNews(){ [weak self] in
 
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.searchedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        let article = DataManager.shared.currentHeadLines[indexPath.row]
        
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.description

        return cell
    }
}
