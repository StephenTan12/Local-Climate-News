//
//  API.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/4/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import Foundation

struct API {
    static func getArticles(page: Int, city: String, state: String, completion: @escaping ([Article]?) -> ()) {
        let apiKey = "070f3b14a49b49ef9180cca7df16c06c"
        let urlString = "https://newsapi.org/v2/everything?q=\(city)%20nature&sortBy=popularity&pageSize=10&page\(page)"
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, res, error ) in
            if let error = error {
                print(error.localizedDescription)
            }
                
            if let data = data {
                let articles = try! JSONDecoder().decode(ArticleResponse.self, from: data)
                completion(articles.articles)
            }
        }
        
        task.resume()
    }
}
