//
//  InternetManager.swift
//  InternetManager
//
//  Created by Pavel Maal on 17.11.23.
//

import Foundation
import UIKit

final public class InternetManager: InternetManagerProtocol {

    // MARK: - Private Properties

    private let session: URLSessionProtocol

    // MARK: - Init

    public init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: - Internal Functions

    public func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = session.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }

    public func getData(with url: URL?, completion: @escaping (Data?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        let task = session.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
}
