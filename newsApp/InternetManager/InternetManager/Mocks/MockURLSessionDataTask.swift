//
//  MockURLSessionDataTask.swift
//  newsApp
//
//  Created by Niff1e on 10.10.23.
//

import Foundation
import UIKit

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
