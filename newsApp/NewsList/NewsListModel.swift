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

    // MARK: - Private properties

    private let decoder = NewsJSONDecoder()
    private let internetManager = InternetManager()

    // MARK: - Private(set) properties

    private(set) var articles: [Article]?

    // MARK: - Internal properties

    let stringURL: String = "https://newsapi.org/v2/everything?q=volleyball&from=2023-04-14&apiKey=37834ecfa8884a25a8bad22c4dc6d114"
    var showAlert: ((_ code: String, _ message: String) -> Void)?
    lazy var dowloadImage: ((_ url: URL?, _ complition: @escaping (UIImage?) -> Void) -> Void) = { [weak self] (url, complition) in
        self?.internetManager.downloadImage(with: url, completion: { img in
            complition(img)
        })
    }

    // MARK: - Private Funtions

    private func getURL(from string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw NewsListError.invalidURL
        }
        return url
    }

    // MARK: - Internal Funtions

    func getData(completion: @escaping ([Article]) -> Void) {
        do {
            let url = try getURL(from: stringURL)
            internetManager.getData(with: url) { [weak self] data in
                guard let jsonData = data else {
                    self?.showAlertOnMain(title: "Whoops...", description: "Data Problems")
                    return
                }
                self?.decoder.decodeNewsJSON(from: jsonData, completion: { [weak self] articles in
                    guard let self = self else { return }
                        self.articles = articles
                        DispatchQueue.main.async {
                            completion(articles)
                        }
                    },
                 complitionError: { [weak self] errorResponce in
                    self?.showAlertOnMain(title: errorResponce.code, description: errorResponce.message)
                })
            }
        } catch NewsListError.invalidURL {
            showAlertOnMain(title: "Whoops...", description: "URL Troubles")
        } catch {
            showAlertOnMain(title: "Whoops...", description: "Wrong")
        }
    }

    func showAlertOnMain(title: String, description: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert?(title, description)
        }
    }
}
