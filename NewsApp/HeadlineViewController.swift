//
//  HeadlineViewController.swift
//  NewsApp
//
//  Created by Cynthia Wang on 8/29/18.
//  Copyright © 2018 Cynthia Wang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HeadlineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let placeholderImage = UIImage(named: "placeholder")
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        DataManager.shared.fetchHeadlineNews(){ [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        
        tableView.refreshControl = refreshControl
        
        DataManager.shared.fetchHeadlineNews(){ [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let controller = segue.destination as? NewsDetailViewController else {
                    print ("Error: Storyboard mis-configuration")
                    return
                }
                
                let headlineArticle = DataManager.shared.currentHeadLines[indexPath.row]
                if let url = URL (string: headlineArticle.urlString!){
                    controller.url = url
                    
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension HeadlineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.currentHeadLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as! HeadlineCell
        
        let headlineArticle = DataManager.shared.currentHeadLines[indexPath.row]
        
        cell.titleLabel.text = headlineArticle.title
        cell.descriptionLabel.text = headlineArticle.description
        
        if let imageUrl = headlineArticle.urlToImage {
            configureCellImage(with:imageUrl, for: cell.urlImage)
            
        } else {
            cell.urlImage.image = placeholderImage
        }
        return cell
    }
    
    func configureCellImage(with URLString: String, for imageView:UIImageView) {
        
        guard let url = URL(string: URLString) else {
            imageView.image = placeholderImage
            return
        }
        
        let size = imageView.frame.size
        
        imageView.af_setImage(
            withURL: url,
            placeholderImage: placeholderImage,
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 0.0),
            imageTransition: .crossDissolve(0.2)
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.size.height/3)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

