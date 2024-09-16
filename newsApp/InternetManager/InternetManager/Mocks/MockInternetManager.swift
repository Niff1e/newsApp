//
//  MockInternetManager.swift
//  newsAppTests
//
//  Created by Niff1e on 15.09.23.
//

import Foundation
import UIKit

class MockInternetManager: InternetManagerProtocol {

    enum ImageType {
        case valid
        case invalid
    }

    enum DataType {
        case successData
        case errorData
        case invalid
    }

    var imageType: ImageType?
    var dataType: DataType?
    let successData =
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
    let errorData =
        """
            {
                "status":"error",
                "code":"1",
                "message":"Test error message"
            }
        """
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        switch imageType {
        case .valid:
            completion(UIImage())
        case .invalid:
            completion(nil)
        default:
            completion(nil)
        }
    }

    func getData(with url: URL?, completion: @escaping (Data?) -> Void) {
        if url == nil {
            imageType = .invalid
        }
        switch dataType {
        case .successData:
            let data = successData.data(using: .utf8)!
            completion(data)
        case .errorData:
            let data = errorData.data(using: .utf8)!
            completion(data)
        case .invalid:
            completion(nil)
        default:
            completion(nil)
        }
    }
}
