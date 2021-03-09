//
//  WebController.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/5/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var url: String!
    var article: Article! {
        didSet {
            url = article.url
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareArticle))
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [shareButton, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let webUrl = URL(string: url)!
        webView.load(URLRequest(url: webUrl))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func shareArticle() {
        guard let websiteUrl = URL(string: url) else {return}
        let ac = UIActivityViewController(activityItems: [websiteUrl], applicationActivities: [])
        present(ac, animated: true)
    }
}
