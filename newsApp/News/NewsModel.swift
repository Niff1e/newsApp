//
//  NewsModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsModel {
    private(set) var picture: UIImage?
    private(set) var content: String?
    private(set) var pictureURL: URL?

    init(image: UIImage?, content: String?, pictureURL: URL?) {
        self.content = content
        self.picture = image
        self.pictureURL = pictureURL
    }
}
