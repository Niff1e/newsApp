//
//  NewsAppModelSlowTests.swift
//  NewsAppSlowTests
//
//  Created by Niff1e on 24.09.23.
//

import XCTest
@testable import newsApp

class NewsAppModelSlowTests: XCTestCase {

    var newsListModel: NewsListModel!
    let internetManager = MockInternetManager()

    override func setUpWithError() throws {
        try super.setUpWithError()
        newsListModel = NewsListModel(internetManager)
    }

    override func tearDownWithError() throws {
        newsListModel = nil
        try super.tearDownWithError()
    }

    func testSuccessDownloadImageOfNewsListModel() {

        // given
        // swiftlint:disable:next line_length
        let stringUrl = "https://newsapi.com"
        let url = URL(string: stringUrl)!
        var finalImage: UIImage?
        internetManager.dataType = .successData
        let promise = expectation(description: "Image downloaded")

        // when
        newsListModel.dowloadImage(url: url) { image in
            finalImage = image
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(finalImage, "Download failed")
    }

    func testSuccessGetArticlesOfNewsListModelWithExistingTheme() {

        // given
        let stringAbout = "volleyball"
        var articles: [Article]?
        internetManager.dataType = .successData
        let promise = expectation(description: "Articles downloaded")

        // when
        newsListModel.getArticles(about: stringAbout) {  result in
            articles = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(articles, "Download failed")
        XCTAssertEqual(articles!.count, 1, "No articles about this theme")
    }

    func testSuccessGetArticlesOfNewsListModelWithInvalidTheme() {
        // given
        let stringAbout = "fgrtbvujnvk"
        var articles: [Article]?
        internetManager.dataType = .invalid
        let promise = expectation(description: "Articles downloaded")

        // when
        newsListModel.getArticles(about: stringAbout) { result in
            articles = result
        }
        promise.fulfill()
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(articles, "Download failed")
    }

    func testSuccessGetArticlesWithErrorData() {
        // given
        var articles: [Article] = []
        internetManager.dataType = .errorData
        let promise = expectation(description: "Articles downloaded")

        // when
        newsListModel.getArticles(about: nil) { result in
            articles = result
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)

        // then
        XCTAssertEqual(articles.count, 0, "Error data not found")
    }
}
