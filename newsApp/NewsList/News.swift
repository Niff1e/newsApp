//
//  JSON Struct.swift
//  newsApp
//
//  Created by Niff1e on 6.03.23.
//

import Foundation

struct News: Codable {
    let status: String
    let totalResults: Double
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: URL
    let urlToImage: URL?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}
