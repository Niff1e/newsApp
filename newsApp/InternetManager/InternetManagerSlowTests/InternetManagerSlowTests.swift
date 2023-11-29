//
//  InternetManagerSlowTests.swift
//  InternetManagerTests
//
//  Created by Pavel Maal on 17.11.23.
//

import XCTest
@testable import InternetManager

final class InternetManagerSlowTests: XCTestCase {

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
        let stringUrl = "https://newsapi.com"
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
        let stringUrl = "https://newsapi.com"
        let url = URL(string: stringUrl)!
        var finalData: Data?
        session.dataType = .validData
        let promise = expectation(description: "Data received")

        // when
        internetManager.getData(with: url) { data in
            let item = DispatchWorkItem {
                finalData = data
                promise.fulfill()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(finalData, "Data receiving failed")
    }


}
