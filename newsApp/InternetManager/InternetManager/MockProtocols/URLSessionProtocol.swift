//
//  URLSessionProtocol.swift
//  InternetManager
//
//  Created by Pavel Maal on 17.11.23.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
