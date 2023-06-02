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
    case badPercentEncoding
}

final class NewsListModel {

    // MARK: - Private properties

    private let decoder = NewsJSONDecoder()
    private let internetManager = InternetManager()
    private var actualTheme: String?
    private var pageSize = 10
    private let maxPageSize = 100
    private var isDownloadingAllowed = true

    // MARK: - Private(set) properties

    private(set) var articles: [Article] = []
    private var isFirstScreen = true

    // MARK: - Internal properties

    var showAlert: ((_ code: String, _ message: String) -> Void)?
    var showNoResult: (() -> Void)?
    var hideNoResult: (() -> Void)?
    var whenStartDownload: (() -> Void)?
    var whenFinishDownload: (() -> Void)?

    // MARK: - Private functions

    private func getURL(numberOfPage: Int, about: String?) throws -> URL {
        var stringURL = String()
        if let about, !about.isEmpty {
            // swiftlint:disable:next line_length
            stringURL = String("https://newsapi.org/v2/everything?q=\(about)&pageSize=\(pageSize)&page=\(numberOfPage)&from=2023-05-10&apiKey=37834ecfa8884a25a8bad22c4dc6d114")
        } else {
            // swiftlint:disable:next line_length
            stringURL = String("https://newsapi.org/v2/top-headlines?pageSize=\(pageSize)&page=\(numberOfPage)&country=us&apiKey=37834ecfa8884a25a8bad22c4dc6d114")
        }
        guard let encodedUrl = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NewsListError.badPercentEncoding
        }
        guard let url = URL(string: encodedUrl) else {
            throw NewsListError.invalidURL
        }
        return url
    }

    // MARK: - Internal Funtions

    func dowloadImage(_ url: URL, _ complition: @escaping (UIImage?) -> Void) {
        self.internetManager.downloadImage(with: url) { img in complition(img)
        }
    }

    func getArticles(about: String?, ifSucces: @escaping ([Article]) -> Void) {
        hideNoResult?()
        var partOfArticles = (articles.count)/pageSize
        about.flatMap { theme in
            isFirstScreen = false
            if actualTheme != theme {
                actualTheme = theme
                articles = []
                partOfArticles = 0
                isDownloadingAllowed = true
                pageSize = 10
            }
        }

        do {
            whenStartDownload?()
            if isDownloadingAllowed {
                let url = try getURL(numberOfPage: partOfArticles + 1, about: actualTheme)
                internetManager.getData(with: url) { [weak self] data in
                    guard let jsonData = data else {
                        self?.showAlertOnMain(title: "whoops", description: "data_fetching_error")
                        return
                    }
                    self?.decoder.decodeNewsJSON(from: jsonData, completionHandler: { [weak self] result in
                        switch result {
                        case .failure(let errorResponse):
                            self?.showAlertOnMain(title: errorResponse.code, description: errorResponse.message)
                        case .success(let successResponce):
                            guard let self = self else { return }
                            print(successResponce.totalResults)
                            if successResponce.totalResults == 0 {
                                self.showNoResult?()
                            }
                            DispatchQueue.main.async {
                                for article in successResponce.articles {
                                    self.articles.append(article)
                                }
                                ifSucces(self.articles)
                                self.whenFinishDownload?()
                                let limit = min(successResponce.totalResults, self.maxPageSize)
                                if self.articles.count == limit {
                                    self.isDownloadingAllowed = false
                                } else if limit < self.articles.count + self.pageSize {
                                    self.pageSize = limit - self.articles.count
                                }
                            }
                        }
                    })
                }
            }
        } catch NewsListError.invalidURL {
            showAlertOnMain(title: "whoops", description: "url_troubles_error")
        } catch NewsListError.badPercentEncoding {
            showAlertOnMain(title: "whoops", description: "bad_encoding_url_error")
        } catch {
            showAlertOnMain(title: "whoops", description: "unexpected_error")
        }
    }

    func showAlertOnMain(title: String, description: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert?(NSLocalizedString(title, comment: ""), NSLocalizedString(description, comment: ""))
        }
    }
}
