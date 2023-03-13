//
//  NewsListModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

enum NewsListErrors: Error {
    case getUrlsError
}

final class NewsListModel {

    // MARK: - Private(set) properties

    var picture: UIImage?
    private let decoder = JSONDecoder()
    let stringURL: String = "https://newsapi.org/v2/everything?q=volleyball&from=2023-03-12&apiKey=37834ecfa8884a25a8bad22c4dc6d114"

    // MARK: - Internal properties
    
    var showAlert: ((_ code: String, _ message: String) -> Void)?

    // MARK: - Internal Funtions

    func getURL(from string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw NewsListErrors.getUrlsError
        }
        return url
    }

    func getData(from stringURL: String) -> [Articles]? {
        do {
            let url = try getURL(from: stringURL)
            let jsonData = try Data(contentsOf: url)
            let news = try decoder.decode(News.self, from: jsonData)
            switch news.status {
            case .ok(let articles):
                return articles
            case .error(let errorResponce):
                showAlert?(errorResponce.code, errorResponce.message)
                return nil
            }
        } catch NewsListErrors.getUrlsError {
            showAlert?("Whoops...", "URL Troubles")
            return nil
        } catch {
            showAlert?("Whoops...", "Wrong")
            print(error)
            return nil
        }
    }

    func downloadImage(with url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.picture = image
            }
        }
        task.resume()
    }
}
