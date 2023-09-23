//
//  NewsAppSlowTests.swift
//  NewsAppSlowTests
//
//  Created by Niff1e on 24.09.23.
//

import XCTest
@testable import newsApp

class NewsAppSlowTests: XCTestCase {

    var sut: InternetManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = InternetManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testSuccessDownloadImage() throws {
        // given
        // swiftlint:disable:next line_length
        let stringUrl = "https://kartinkof.club/uploads/posts/2022-05/1653010381_5-kartinkof-club-p-kartinka-zastavka-schaste-5.jpg"
        let url = URL(string: stringUrl)!
        var finalImage: UIImage?
        let promise = expectation(description: "Image downloaded")

        // when
        sut.downloadImage(with: url) { image in
            finalImage = image
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(finalImage, "Download failed")
    }
}
