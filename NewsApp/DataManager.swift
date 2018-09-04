//
//  DataManager.swift
//  NewsApp
//
//  Created by Cynthia Wang on 9/1/18.
//  Copyright © 2018 Cynthia Wang. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage

class DataManager {
    
    let concurrentQueue = DispatchQueue(label: "com.wang.newsapp.network",
                              qos: .userInitiated,
                              attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "com.wang.newsapp.updatedata",
                                    qos: .userInitiated,
                                    attributes: .concurrent)
    
    let topUSNewsUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9090f1da912f469ab2079b141f79809a"
    
    static var shared: DataManager = DataManager()
    
    var currentHeadLines = [Article]()
    
    var _filteredNews = [Article]()
    var filteredNews: [Article] {
        get {
            return serialQueue.sync{ _filteredNews }
        }
        set {
            serialQueue.sync{ [weak self] in
                self?._filteredNews = newValue
            }
        }
    }
    
    func fetchHeadlineNews(completion:@escaping ()->Void) {

        Alamofire.request(topUSNewsUrl).responseObject(queue: concurrentQueue) {(response: DataResponse<ArticleResponse>) in
            
            guard let articleResponse = response.result.value else {
                return
            }
            if let articles = articleResponse.articles {
                DataManager.shared.currentHeadLines = articles
            }
            completion()
        }
    }
    
    func fetchFilteredNews(with text: String?, completion: @escaping ()->Void) {
        guard let text = text,
            let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else { return }

        let searchUrl = "https://newsapi.org/v2/everything?q=" + escapedString + "&apiKey=9090f1da912f469ab2079b141f79809a"
        
        Alamofire.request(searchUrl).responseObject(queue: concurrentQueue) {(response: DataResponse<ArticleResponse>) in
            
            guard let articleResponse = response.result.value else {
                return
            }
            if let articles = articleResponse.articles {
                DataManager.shared.filteredNews = articles
                if let url = response.request?.url {
                    print("Back from URL request: \(url)")
                }
            }
            completion()
        }
    }
}
