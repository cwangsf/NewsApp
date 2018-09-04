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
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var url: URL = URL(string: "https://www.google.com" )!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        activityIndicatorView.startAnimating()
        webView.load(URLRequest(url:url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
}
