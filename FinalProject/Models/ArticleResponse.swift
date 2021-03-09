//
//  ArticleResponse.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/4/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
