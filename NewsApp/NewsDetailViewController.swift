//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Cynthia Wang on 9/3/18.
//  Copyright © 2018 Cynthia Wang. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var url: URL = URL(string: "https://www.google.com" )!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url:url))
        
        
    }
    
}
