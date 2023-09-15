//
//  newsAppTests.swift
//  newsAppTests
//
//  Created by Niff1e on 27.02.23.
//

import XCTest
@testable import newsApp

class NewsAppTests: XCTestCase {

    private var newsListModel: NewsListModel!

    override func setUp() {
        super.setUp()

        newsListModel = NewsListModel()
    }

    override func tearDown() {
        newsListModel = nil

        super.tearDown()
    }

    func testDownloadImageMethod() {
        let model = NewsListModel(internetManager: MockInternetManager() as InternetManagerProtocol)
    }
}
