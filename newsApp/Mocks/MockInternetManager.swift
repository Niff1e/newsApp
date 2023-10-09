//
//  MockInternetManager.swift
//  newsAppTests
//
//  Created by Niff1e on 15.09.23.
//

import Foundation
import UIKit
@testable import newsApp

class MockInternetManager: InternetManagerProtocol {

    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {}
    func getData(with url: URL?, completion: @escaping (Data?) -> Void) {}

}
