//
//  Article.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/4/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import Foundation

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}
