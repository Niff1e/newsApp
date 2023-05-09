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

    // MARK: - Internal Funtions

    func dowloadImage(_ url: URL?, _ complition: @escaping (UIImage?) -> Void) {
        self.internetManager.downloadImage(with: url) { img in complition(img)
        }
    }

    func getArticles(about: String?, ifSucces: @escaping ([Article]) -> Void) {
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
                self?.decoder.decodeNewsJSON(from: jsonData, completionHandler: { [weak self] result in
                    switch result {
                    case .failure(let errorResponse):
                        self?.showAlertOnMain(title: errorResponse.code, description: errorResponse.message)
                    case .success(let articles):
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            for article in articles {
                                self.articles.append(article)
                            }
                            ifSucces(self.articles)
                        }
                    }
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
