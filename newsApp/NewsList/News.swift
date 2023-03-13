//
//  JSON Struct.swift
//  newsApp
//
//  Created by Niff1e on 6.03.23.
//

import Foundation

enum Status: Codable {
    case ok([Article])
    case error(String, String)
}

struct News: Codable {
    let status: Status
}

struct Article: Codable {
    let title: String
    let description: String
    let url: URL
    let urlToImage: URL?
    let content: String?
}
