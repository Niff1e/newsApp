//
//  JSONDecoder.swift
//  newsApp
//
//  Created by Niff1e on 16.04.23.
//

import Foundation
import UIKit

final class NewsJSONDecoder: JSONDecoder {

    func decodeNewsJSON(from jsonData: Data, completion: @escaping (([Article]) -> Void), complitionError: @escaping (ErrorResponse) -> Void) {
        do {
            let news = try self.decode(News.self, from: jsonData)
            switch news {
            case .ok(let articles):
                DispatchQueue.main.async {
                    completion(articles)
                }
            case .error(let errorResponse):
                complitionError(errorResponse)
            }
        } catch {
            complitionError(ErrorResponse(code: "Whoops...", message: "Decode Problems"))
        }
    }
}
