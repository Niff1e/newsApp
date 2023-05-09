//
//  InternetManager.swift
//  newsApp
//
//  Created by Niff1e on 14.04.23.
//

import Foundation
import UIKit

final class InternetManager {

    // MARK: - Private Properties

    private var stringURL: (Int, String) -> String = { (number, about) in
        // swiftlint:disable:next line_length
        return String("https://newsapi.org/v2/everything?q=\(about)&pageSize=10&page=\(number)&from=2023-04-14&apiKey=37834ecfa8884a25a8bad22c4dc6d114")
    }

    // MARK: - Private Functions

    private func getURL(from string: (Int, String) -> String, part: Int, about: String?) throws -> URL {
        let stringURL = string(part, about ?? "anithing")
        guard let url = URL(string: stringURL) else {
            throw NewsListError.invalidURL
        }
        return url
    }

    // MARK: - Internal Functions

    func downloadImage(with url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }

    func getData(about: String?, part: Int, completion: @escaping (Data?) -> Void) throws {
        do {
            let url = try getURL(from: stringURL, part: part, about: about)
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            task.resume()
        }
    }
}
