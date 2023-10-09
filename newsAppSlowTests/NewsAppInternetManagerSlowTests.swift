//
//  NewsAppInternetManagerSlowTests.swift
//  newsAppSlowTests
//
//  Created by Niff1e on 10.10.23.
//

import XCTest
@testable import newsApp

final class NewsAppInternetManagerSlowTests: XCTestCase {

    var internetManager: InternetManager!
    let session = MockURLSession()

    override func setUpWithError() throws {
        try super.setUpWithError()
        internetManager = InternetManager(session)
    }

    override func tearDownWithError() throws {
        internetManager = nil
        try super.tearDownWithError()
    }

    func testSuccessDownloadImage() throws {
        // given
        // swiftlint:disable:next line_length
        let stringUrl = "https://kartinkof.club/uploads/posts/2022-05/1653010381_5-kartinkof-club-p-kartinka-zastavka-schaste-5.jpg"
        let url = URL(string: stringUrl)!
        var finalImage: UIImage?
        session.dataType = .validImage
        let promise = expectation(description: "Image downloaded")

        // when
        internetManager.downloadImage(with: url) { image in
            let item = DispatchWorkItem {
                finalImage = image
                promise.fulfill()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(finalImage, "Download failed")
    }

    func testSuccessGetData() throws {
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

}
