//
//  NewsAppModelTests.swift
//  newsAppTests
//
//  Created by Niff1e on 9.10.23.
//

import XCTest
@testable import newsApp

final class NewsAppModelTests: XCTestCase {

    var sut: NewsListModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NewsListModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
}
