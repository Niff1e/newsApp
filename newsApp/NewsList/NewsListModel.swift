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
    private var actualTheme: String = ""

    // MARK: - Private(set) properties

    private(set) var articles: [Article] = []

    // MARK: - Internal properties

    var showAlert: ((_ code: String, _ message: String) -> Void)?
    lazy var dowloadImage: ((_ url: URL?, _ complition: @escaping (UIImage?) -> Void) -> Void) = { [weak self] (url, complition) in
        self?.internetManager.downloadImage(with: url, completion: { img in
            complition(img)
        })
    }

    // MARK: - Internal Funtions

    func getArticles(about: String?, completion: @escaping ([Article]) -> Void) {
        var partOfArticles = (articles.count)/10
        guard let about = about else { return }
        if actualTheme != about {
            actualTheme = about
            articles = []
            partOfArticles = 0
        }
        do {
            try internetManager.getData(about: actualTheme, part: partOfArticles + 1) { [weak self] data in
                guard let jsonData = data else {
                    self?.showAlertOnMain(title: "Whoops...", description: "Data Problems")
                    return
                }
                self?.decoder.decodeNewsJSON(from: jsonData, completion: { [weak self] newArticles in
                    guard let self = self else { return }
                        DispatchQueue.main.async {
                            for article in newArticles {
                                self.articles.append(article)
                            }
                            completion(self.articles)
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
