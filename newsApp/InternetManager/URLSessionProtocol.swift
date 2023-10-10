//
//  URLSessionProtocol.swift
//  newsApp
//
//  Created by Niff1e on 10.10.23.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
