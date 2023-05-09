//
//  JSONDecoder.swift
//  newsApp
//
//  Created by Niff1e on 16.04.23.
//

import Foundation
import UIKit

final class NewsJSONDecoder: JSONDecoder {

    func decodeNewsJSON(from jsonData: Data,
                        completionHandler: @escaping (Result<[Article], ErrorResponse>) -> Void) {
        do {
            let news = try self.decode(News.self, from: jsonData)
            switch news {
            case .ok(let articles):
                completionHandler(.success(articles))
            case .error(let errorResponse):
                completionHandler(.failure(errorResponse))
            }
        } catch {
            completionHandler(.failure(ErrorResponse(code: "Whoops...", message: "Decode Problems")))
        }
    }
}
