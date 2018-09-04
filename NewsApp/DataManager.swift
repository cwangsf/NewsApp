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

class ArticleResponse: Mappable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
    
    required init?(map:Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }
}

class Article: Mappable {
    //var author:String
    var title: String?
    var description: String?
    var urlString: String?
    var urlToImage: String?
    
    required init?(map:Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        urlString <- map["url"]
        urlToImage <- map["urlToImage"]
    }
}

class ArticleSource: Mappable {
    var id: String?
    var name: String?
    required init?(map:Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

class DataManager {
    
    let queue = DispatchQueue(label: "com.wang.newsapp",
                              qos: .userInitiated,
                              attributes: .concurrent)
    
    let topUSNewsUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9090f1da912f469ab2079b141f79809a"
    
    let allNewsWithQueryUrl = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=9090f1da912f469ab2079b141f79809a"
    
    static var shared: DataManager = DataManager()
    
    var currentHeadLines = [Article]()
    
    var searchedNews = [Article]()
    
    func fetchHeadlineNews(completion:@escaping ()->Void) {
        
        
        Alamofire.request(topUSNewsUrl).responseObject(queue: queue) {(response: DataResponse<ArticleResponse>) in
            
            guard let articleResponse = response.result.value else {
                return
            }
            if let articles = articleResponse.articles {
                DataManager.shared.currentHeadLines = articles

            }
            completion()
            
        }
    }
    
    func fetchFilteredNews(completion: @escaping ()->Void) {
        //let searchUrl = allNewsWithQueryUrl
        Alamofire.request(allNewsWithQueryUrl).responseObject(queue: queue) {(response: DataResponse<ArticleResponse>) in
            
            guard let articleResponse = response.result.value else {
                return
            }
            if let articles = articleResponse.articles {
                DataManager.shared.searchedNews = articles
                
            }
            completion()
            
        }
    }


}
