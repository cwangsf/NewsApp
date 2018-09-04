//
//  DataModel.swift
//  NewsApp
//
//  Created by Cynthia Wang on 9/4/18.
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
    var source: ArticleSource?
    
    required init?(map:Map) {
        mapping(map:map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        urlString <- map["url"]
        urlToImage <- map["urlToImage"]
        source <- map["source"]
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
