//
//  MockInternetManager.swift
//  newsAppTests
//
//  Created by Niff1e on 15.09.23.
//

import Foundation
import UIKit

class MockInternetManager: InternetManagerProtocol {

    enum DataType {
        case valid
        case invalid
    }

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
    let stringData =
        """
            {
                "status":"error",
                "code":"1",
                "message":"Test error message"
            }
        """
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        switch dataType {
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
            dataType = .invalid
        }
        switch dataType {
        case .valid:
            let data = successData.data(using: .utf8)!
            completion(data)
        case .invalid:
            completion(nil)
        default:
            completion(nil)
        }
    }
}
