//
//  newsAppDecoderTests.swift
//  newsAppTests
//
//  Created by Niff1e on 27.02.23.
//

import XCTest
@testable import newsApp

final class NewsAppDecoderTests: XCTestCase {

    var sut: NewsJSONDecoder!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NewsJSONDecoder()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testDecodeNewsJSONMethodWithSuccessCompletion() {

        // given
        let stringData =
            """
                {
                    "status":"ok",
                    "totalResults":1,
                    "articles":
                        [
                            {
                                "content":"content"
                            }
                        ]
                }
            """
        let jsonData = stringData.data(using: .utf8)!
        var finalSuccessResponse: SuccessResponse?

        // when
        sut.decodeNewsJSON(from: jsonData) { result in
            switch result {
            case .success(let successResponse):
                finalSuccessResponse = successResponse
            case .failure(_):
                XCTFail("Wrong structure of json")
            }
        }

        // then
        XCTAssertNotNil(finalSuccessResponse, "Decode of json-data failed")
        XCTAssertEqual(finalSuccessResponse!.articles[0].content, "content")
    }

    func testDecodeNewsJSONMethodWithErrorResponseCompletion() {

        // given
        let stringData =
            """
                {
                    "status":"error",
                    "code":"1",
                    "message":"Test error message"
                }
            """
        let jsonData = stringData.data(using: .utf8)!
        var finalErrorResponse: ErrorResponse?

        // when
        sut.decodeNewsJSON(from: jsonData) { result in
            switch result {
            case .success(_):
                XCTFail("Wrong structure of json")
            case .failure(let errorResponse):
                finalErrorResponse = errorResponse
            }
        }

        // then
        XCTAssertNotNil(finalErrorResponse, "Decode of json-data failed")
        XCTAssertEqual(finalErrorResponse!.message, "Test error message")
        XCTAssertEqual(finalErrorResponse!.code, "1")
    }

    func testJSONDecoderThrowError() {

        // given
        let jsonData = "1".data(using: .utf8)!
        var finalErrorResponse: ErrorResponse?

        // when
        sut.decodeNewsJSON(from: jsonData) { result in
            switch result {
            case .success(_):
                XCTFail("Wrong structure of json")
            case .failure(let errorResponse):
                finalErrorResponse = errorResponse
            }
        }

        // then
        XCTAssertNotNil(finalErrorResponse, "Decode of json-data failed")
        XCTAssertEqual(finalErrorResponse!.message, .dataDecodingError)
    }
}
