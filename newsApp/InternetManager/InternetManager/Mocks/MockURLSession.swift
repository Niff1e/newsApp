//
//  MockURLSession.swift
//  newsAppTests
//
//  Created by Niff1e on 9.10.23.
//

import Foundation
import UIKit

class MockURLSession: URLSessionProtocol {

    enum DataType {
        case validData
        case validImage
        case invalid
    }

    var dataTask = MockURLSessionDataTask()
    var dataType: DataType?
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

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {

        switch dataType {
        case .validData:
            let data = stringData.data(using: .utf8)!
            completionHandler(data, nil, nil)
        case .validImage:
            let image = UIImage(systemName: "heart.fill")!
            let data = image.pngData()!
            completionHandler(data, nil, nil)
        default:
            completionHandler(nil, nil, nil)
        }
        return dataTask
    }
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url,
                         completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

