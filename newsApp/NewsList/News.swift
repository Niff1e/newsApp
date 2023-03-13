//
//  JSON Struct.swift
//  newsApp
//
//  Created by Niff1e on 6.03.23.
//

import Foundation

enum Status: Decodable {
    case ok([Articles])
    case error(ErrorResponse)

    enum CodingKeys: String, CodingKey {
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(ResponceType.self, forKey: .status)
        switch status {
        case .error:
            self = .error(try container.decode(ErrorResponse.self, forKey: .status))
        case .ok:
            self = .ok(try container.decode([Articles].self, forKey: .status))
        }
    }
}

struct News: Decodable {
    let status: Status
}

struct Articles: Decodable {
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let content: String?
}

struct ErrorResponse: Decodable {
    let code: String
    let message: String
}

enum ResponceType: String, Decodable {
    case ok, error
}
