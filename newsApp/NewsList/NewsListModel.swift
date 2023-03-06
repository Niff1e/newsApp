//
//  NewsListModel.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsListModel {

    private let decoder = JSONDecoder()
    
    let stringURL: String = "https://newsapi.org/v2/everything?q=volleyball&from=2023-03-05&apiKey=37834ecfa8884a25a8bad22c4dc6d114"

    func getData() -> News? {
        guard let url = URL(string: stringURL) else { return nil }
        do {
            let jsonData = try Data(contentsOf: url)
            let news = try decoder.decode(News.self, from: jsonData)
            return news
        } catch {
            print(error)
            return nil
        }
    }

    func downloadImage(with url: URL) -> UIImage {
        var finalImage = UIImage()
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            finalImage = image
        }
        task.resume()
        return finalImage
    }
}
