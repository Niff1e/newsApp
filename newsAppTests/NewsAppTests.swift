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
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetDataMethodWithNilURL() {

        // given
        let internetManager = InternetManager()
        var finalData: Data?
        let url = URL(string: "")

        // when
        internetManager.getData(with: url) { data in
            finalData = data
        }

        // then
        XCTAssertNil(finalData, "Valid URL")
    }
}
