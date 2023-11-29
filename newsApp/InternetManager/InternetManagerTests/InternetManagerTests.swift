//
//  InternetManagerTests.swift
//  InternetManagerTests
//
//  Created by Pavel Maal on 9.11.23.
//

import XCTest
@testable import InternetManager

final class InternetManagerTests: XCTestCase {

    let session = MockURLSession()
    var sut: InternetManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = InternetManager(session)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testGetDataMethodWithNilURL() {

        // given
        var finalData: Data?
        let url: URL? = nil
        session.dataType = .invalid

        // when
        sut.getData(with: url) { data in
            finalData = data
        }

        // then
        XCTAssertNil(finalData, "Valid URL")
    }
}
