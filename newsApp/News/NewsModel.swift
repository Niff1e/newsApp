//
//  NewsModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsModel {

    // MARK: - Private(set) Properties

    private(set) var article: Article?

    // MARK: - Private Properties

    private let internetManager = InternetManager()

    // MARK: - Internal Properties

    var updatePicture: ((UIImage?) -> Void)?

    // MARK: - Init

    init(article: Article?) {
        self.article = article
    }

    // MARK: - Internal Functions

    func dowloadImage() {
        internetManager.downloadImage(with: article?.urlToImage) { [weak self] img in
            DispatchQueue.main.async { [weak self] in
                self?.updatePicture?(img)
            }
        }
    }
}
