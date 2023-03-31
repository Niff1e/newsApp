//
//  JSON Struct.swift
//  newsApp
//
//  Created by Niff1e on 6.03.23.
//

import Foundation

enum News: Decodable {
    case ok([Article])
    case error(ErrorResponse)

    enum CodingKeys: String, CodingKey {
        case status, articles, code, message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(ResponceType.self, forKey: .status)
        switch status {
        case .error:
            let code = try container.decode(String.self, forKey: .code)
            let message = try container.decode(String.self, forKey: .message)
            self = .error(ErrorResponse.init(code: code, message: message))
        case .ok:
            let articles = try container.decode([Article].self, forKey: .articles)
            self = .ok(articles)
        }
    }
}

struct Article: Decodable {
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let content: String?

    enum CodingKeys: CodingKey {
        case title
        case description
        case url
        case urlToImage
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        let url = try container.decodeIfPresent(String.self, forKey: .url)
        self.url = URL(string: url ?? "")
        let urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.urlToImage = URL(string: urlToImage?.getCString(<#T##buffer: &[CChar]##[CChar]#>, maxLength: 300, encoding: .utf8) ?? "")
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
    }
}

struct ErrorResponse: Decodable {
    let code: String
    let message: String
}

enum ResponceType: String, Decodable {
    case ok, error
}
