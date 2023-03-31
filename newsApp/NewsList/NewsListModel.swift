//
//  NewsListModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

enum NewsListError: Error {
    case invalidURL
    case clientsError
    case emptyArrayOfArticles
}

final class NewsListModel {

    // MARK:  Private properties

    private let decoder = JSONDecoder()
    private var articles: [Article]?

    // MARK: - Internal properties

    let stringURL: String = "https://newsapi.org/v2/everything?q=volleyball&from=2023-03-29&apiKey=37834ecfa8884a25a8bad22c4dc6d114"
    var showAlert: ((_ code: String, _ message: String) -> Void)?

    // MARK: - Private Funtions

    private func getURL(from string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw NewsListError.invalidURL
        }
        return url
    }

    // MARK: - Internal Funtions

    func getData(from stringURL: String, completion: @escaping ([Article]) -> Void) {
        do {
            let url = try getURL(from: stringURL)
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard error == nil else {
                    self.showAlert?("Whoops...", error.debugDescription)
                    return
                }
                guard let jsonData = data else {
                    self.showAlert?("Whoops...", "Data Problems")
                    return
                }
                do {
                    let news = try self.decoder.decode(News.self, from: jsonData)
                    switch news {
                    case .ok(let articles):
                        self.articles = articles
                        completion(articles)
                    case .error(let errorResponce):
                        self.showAlert?(errorResponce.code, errorResponce.message)
                        return
                    }
                } catch {
                    self.showAlert?("Whoops...", "Decode Problems")
                }
            }
            task.resume()
        } catch NewsListError.invalidURL {
            showAlert?("Whoops...", "URL Troubles")
        } catch {
            showAlert?("Whoops...", "Wrong")
            print(error)
        }
    }

    func downloadImage(with url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { 
                completion(image)
            }
        }
        task.resume()
    }

    func getArticle(forRowNumber rowNumber: Int) throws -> Article {
        guard let articles = articles else { throw NewsListError.emptyArrayOfArticles }
        return articles[rowNumber]
    }

    func getArticlesCount() throws -> Int {
        guard let articles = articles else { throw NewsListError.emptyArrayOfArticles }
        return articles.count
    }
}
