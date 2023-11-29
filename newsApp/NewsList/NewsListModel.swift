//
//  NewsListModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit
import InternetManager

enum NewsListError: Error {
    case invalidURL
    case badPercentEncoding
}

final class NewsListModel {

    // MARK: - Private properties

    private let decoder = NewsJSONDecoder()
    private let internetManager: InternetManagerProtocol
    private var actualTheme: String?
    private var partOfArticles: Int = 0
    private var pageSize = 10
    private let maxPageSize = 100
    private var isStartScreen = true
    private var isDownloadingAllowed = true

    // MARK: - Init

    init(_ internetManager: InternetManagerProtocol = InternetManager()) {
        self.internetManager = internetManager
    }

    // MARK: - Private(set) properties

    private(set) var articles: [Article] = []

    // MARK: - Internal properties

    var showAlert: ((_ code: String, _ message: String) -> Void)?
    var isNoResultLabelVisible: ((Bool) -> Void)?
    var isSpinnerAnimated: ((Bool) -> Void)?

    // MARK: - Private functions

    private func getURL(numberOfPage: Int, about: String?) throws -> URL {
        var stringURL = String()
        if self.isStartScreen {
            // swiftlint:disable:next line_length
            stringURL = String("https://newsapi.org/v2/top-headlines?pageSize=\(pageSize)&page=\(numberOfPage)&country=us&apiKey=43a0ca0dfa144c40b500339ab44741ea")
        } else {
            if let about {
                // swiftlint:disable:next line_length
                stringURL = String("https://newsapi.org/v2/everything?q=\(about)&pageSize=\(pageSize)&page=\(numberOfPage)&from=\(conversionDateToString(date: Date()))&apiKey=43a0ca0dfa144c40b500339ab44741ea")
            }
        }
        guard let encodedUrl = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NewsListError.badPercentEncoding
        }
        guard let url = URL(string: encodedUrl) else {
            throw NewsListError.invalidURL
        }
        return url
    }

    private func showAlertOnMain(title: String, description: String, isNoResultLabelVisible: Bool,
                                 isSpinnerAnimated: Bool) {
        DispatchQueue.main.async {
            self.isSpinnerAnimated?(isSpinnerAnimated)
            self.isNoResultLabelVisible?(isNoResultLabelVisible)
            self.showAlert?(title, description)
        }
    }

    private func checkingForANewTopic(topic: String?) {
        topic.flatMap { topic in
            if actualTheme != topic {
                actualTheme = topic
                articles = []
                isDownloadingAllowed = true
                pageSize = 10
            }
        }
    }

    private func checkingForTheExactNumberOfArticles(number: Int) {
        let limit = min(number, self.maxPageSize)
        if self.articles.count == limit {
            self.isDownloadingAllowed = false
        } else if limit < self.articles.count + self.pageSize {
            self.pageSize = limit - self.articles.count
        }
    }

    private func handlingRequest(data: Data?,
                                 completionHandler: @escaping (Result<SuccessResponse, ErrorResponse>) -> Void) {
        guard let jsonData = data else {
            showAlertOnMain(title: .whoops, description: .dataFetchingError, isNoResultLabelVisible: true,
                            isSpinnerAnimated: false)
            return
        }

        decoder.decodeNewsJSON(from: jsonData) { result in
            completionHandler(result)
        }
    }

    private func conversionDateToString(date: Date) -> String {
        guard let actualNewsDate = Calendar.current.date(byAdding: .month, value: -1, to: date) else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: actualNewsDate)
        return stringDate
    }

    private func successResponseHandling(response: SuccessResponse) {
        isSpinnerAnimated?(false)

        if response.totalResults == 0 {
            // articles = []
            isNoResultLabelVisible?(true)
        }

        articles += response.articles
        checkingForTheExactNumberOfArticles(number: response.totalResults)
    }

    // MARK: - Internal Funtions

    func dowloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        internetManager.downloadImage(with: url) { completion($0) }
    }

    func getArticles(about: String?, completionHandler: @escaping ([Article]) -> Void) {
        isNoResultLabelVisible?(false)
        checkingForANewTopic(topic: about)
        partOfArticles = (articles.count)/pageSize
        do {
            if isDownloadingAllowed {
                isSpinnerAnimated?(true)
                let url = try getURL(numberOfPage: partOfArticles + 1, about: actualTheme)
                internetManager.getData(with: url) { [weak self] data in
                    self?.handlingRequest(data: data) { [weak self] result in
                        switch result {
                        case .failure(let errorResponse):
                            guard let strongSelf = self else { return }
                            DispatchQueue.main.async {
                                completionHandler(strongSelf.articles)
                                var statusOfNoResultLabel = true
                                if strongSelf.articles.count != 0 {
                                    statusOfNoResultLabel = false
                                }
                                self?.showAlertOnMain(title: errorResponse.code, description: errorResponse.message,
                                                      isNoResultLabelVisible: statusOfNoResultLabel, isSpinnerAnimated: false)
                            }
                        case .success(let successResponse):
                            guard let strongSelf = self else { return }
                            DispatchQueue.main.async {
                                strongSelf.successResponseHandling(response: successResponse)
                                completionHandler(strongSelf.articles)
                            }
                        }
                    }
                }
            }
        } catch NewsListError.invalidURL {
            showAlertOnMain(title: .whoops, description: .invalidUrl, isNoResultLabelVisible: true,
                            isSpinnerAnimated: false)
        } catch NewsListError.badPercentEncoding {
            showAlertOnMain(title: .whoops, description: .badEncodingUrl, isNoResultLabelVisible: true,
                            isSpinnerAnimated: false)
        } catch {
            showAlertOnMain(title: .whoops, description: .unexpectedError, isNoResultLabelVisible: true,
                            isSpinnerAnimated: false)
        }
    }

    func setIsFirstScreen(to value: Bool) {
        self.isStartScreen = value
    }

    func setFirstPartOfArticles() {
        self.partOfArticles = 0
    }
}

extension String {
    static let whoops = NSLocalizedString("whoops",
                                          comment: "Title of alert")
    static let invalidUrl = NSLocalizedString("invalid_url_error",
                                              comment: "Incorrect builded url")
    static let badEncodingUrl = NSLocalizedString("bad_encoding_url_error",
                                                  comment: "Incorrect encoding special symbols")
    static let unexpectedError = NSLocalizedString("unexpected_error",
                                                   comment: "Some unexpected error")
    static let navigationBarName = NSLocalizedString("navigation_bar_name",
                                                     comment: "Name of navigation bar of table view controller")
    static let alertButton = NSLocalizedString("alert_button",
                                               comment: "Name of alert button")
    static let dataFetchingError = NSLocalizedString("data_fetching_error",
                                                     comment: "Fetching error troubles")
    static let dataDecodingError = NSLocalizedString("data_decoding_error",
                                                     comment: "Decoding json-data to string troubles")
    static let tableController = NSLocalizedString("table_controller",
                                                   comment: "Name of table controller's tab bar item")
    static let collectionController = NSLocalizedString("collection_controller",
                                                        comment: "Name of collection controller's tab bar item")
    static let stackController = NSLocalizedString("stack_controller",
                                                   comment: "Name of stack controller's tab bar item")
}
