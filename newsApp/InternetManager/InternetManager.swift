//
//  InternetManager.swift
//  newsApp
//
//  Created by Niff1e on 14.04.23.
//

import Foundation
import UIKit

final class InternetManager {

    // MARK: - Private Properties

    private let session: URLSession

    // MARK: - Init

    init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - Internal Functions

    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = session.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }

    func getData(with url: URL?, completion: @escaping (Data?) -> Void) {
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
