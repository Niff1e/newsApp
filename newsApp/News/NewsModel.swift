//
//  NewsModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit
import InternetManager

final class NewsModel {

    // MARK: - Static Properties

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Private(set) Properties

    private(set) var article: Article

    // MARK: - Private Properties

    private let internetManager = InternetManager()

    // MARK: - Internal Properties

    var updatePicture: ((UIImage?) -> Void)?

    // MARK: - Init

    init(article: Article) {
        self.article = article
    }

    // MARK: - Internal Functions

    func convertDataToString() -> String {
        var date = String()
        article.publishedAt.flatMap { publisheDate in
            date = NewsModel.formatter.string(from: publisheDate)
        }
        return date
    }

    func dowloadImage() {
        guard let urlToImage = article.urlToImage else {
            DispatchQueue.main.async { [weak self] in
                self?.updatePicture?(nil)
            }
            return
        }
        internetManager.downloadImage(with: urlToImage) { [weak self] img in
            DispatchQueue.main.async { [weak self] in
                self?.updatePicture?(img)
            }
        }
    }
}
