//
//  NewsAppSlowTests.swift
//  NewsAppSlowTests
//
//  Created by Niff1e on 24.09.23.
//

import XCTest
@testable import newsApp

class NewsAppSlowTests: XCTestCase {

    var internetManager: InternetManager!
    var newsListModel: NewsListModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        internetManager = InternetManager()
        newsListModel = NewsListModel()
    }

    override func tearDownWithError() throws {
        internetManager = nil
        newsListModel = nil
        try super.tearDownWithError()
    }

    func testSuccessDownloadImageOfInternetManager() throws {
        // given
        // swiftlint:disable:next line_length
        let stringUrl = "https://kartinkof.club/uploads/posts/2022-05/1653010381_5-kartinkof-club-p-kartinka-zastavka-schaste-5.jpg"
        let url = URL(string: stringUrl)!
        var finalImage: UIImage?
        let promise = expectation(description: "Image downloaded")

        // when
        internetManager.downloadImage(with: url) { image in
            finalImage = image
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(finalImage, "Download failed")
    }

    func testGetData() throws {
        // given
        // swiftlint:disable:next line_length
        let stringUrl = "https://kartinkof.club/uploads/posts/2022-05/1653010381_5-kartinkof-club-p-kartinka-zastavka-schaste-5.jpg"
        let url = URL(string: stringUrl)!
        var finalData: Data?
        let promise = expectation(description: "Data received")

        // when
        internetManager.getData(with: url) { data in
            finalData = data
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(finalData, "Data receiving failed")
    }

    func testSuccessDownloadImageOfNewsListModel() {

        // given
        // swiftlint:disable:next line_length
        let stringUrl = "https://kartinkof.club/uploads/posts/2022-05/1653010381_5-kartinkof-club-p-kartinka-zastavka-schaste-5.jpg"
        let url = URL(string: stringUrl)!
        var finalImage: UIImage?
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
        let promise = expectation(description: "Articles downloaded")

        // when
        newsListModel.getArticles(about: stringAbout) {  result in
            articles = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(articles, "Download failed")
        XCTAssertNotEqual(articles!.count, 0, "No articles about this theme")
    }

    func testSuccessGetArticlesOfNewsListModelWithInvalidTheme() {
        // given
        let localModel = NewsListModel()
        let stringAbout = "fgrtbvujnvk"
        var articles: [Article]?
        let promise = expectation(description: "Articles downloaded")

        // when
        localModel.getArticles(about: "") { _ in

        }
        localModel.getArticles(about: stringAbout) { result in
            articles = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(articles, "Download failed")
        XCTAssertEqual(articles!.count, 0, "No articles about this theme")
    }
}
