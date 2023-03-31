//
//  ViewController.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsListViewController: UITableViewController {

    // MARK: - Private Properties

    private let model: NewsListModel
    private let newsListView = NewsListView()
    private var int = 0

    // MARK: - Init

    init(model: NewsListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Functions

    private func setupNavigation() {
        navigationItem.title = "NEWS"
        guard let nav = navigationController?.navigationBar else { return }
        nav.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    private func showAlert(with code: String, and message: String) {
        let alert = UIAlertController(title: code, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()

        model.getData(from: model.stringURL) { [weak self] articles in
            self?.newsListView.setNumberOfRows(number: articles.count)
        }
    }

    override func loadView() {
        view = newsListView

        model.showAlert = { [weak self] (code, message) -> Void in
            self?.showAlert(with: code, and: message)
        }

        newsListView.creationOfNewsVC = { [weak self] (number) -> Void in
            guard let strongSelf = self else { return }
            do {
                let articleForNumber = try strongSelf.model.getArticle(forRowNumber: number)
                strongSelf.model.downloadImage(with: articleForNumber.urlToImage) { img in
                        let model = NewsModel(image: img, content: articleForNumber.content, pictureURL: articleForNumber.urlToImage)
                        let newsVC = NewsViewController(model: model)
                        strongSelf.navigationController?.pushViewController(newsVC, animated: true)
                }
            } catch NewsListError.emptyArrayOfArticles {
                strongSelf.showAlert(with: "Whoops...", and: "Empty Array")
            } catch {
                strongSelf.showAlert(with: "Whoops...", and: "Unexpected Error")
            }
        }

        newsListView.pictureToCell = { [weak self] (number, completion) in
            guard let strongSelf = self else { return }
            do {
                let articleForNumber = try strongSelf.model.getArticle(forRowNumber: number)
                guard let urlPicture = articleForNumber.urlToImage else {
                    completion(nil)
                    return
                }
                strongSelf.model.downloadImage(with: urlPicture) { img in
                    completion(img)
                }
            } catch NewsListError.emptyArrayOfArticles {
                strongSelf.showAlert(with: "Whoops...", and: "Empty Array")
            } catch {
                strongSelf.showAlert(with: "Whoops...", and: "Unexpected Error")
            }
        }

        newsListView.textForTitleLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            do {
                let articleForNumber = try strongSelf.model.getArticle(forRowNumber: number)
                return articleForNumber.title
            } catch NewsListError.emptyArrayOfArticles {
                strongSelf.showAlert(with: "Whoops...", and: "Empty Array")
                return nil
            } catch {
                strongSelf.showAlert(with: "Whoops...", and: "Unexpected Error")
                return nil
            }
        }

        newsListView.textForDescriptionLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            do {
                let articleForNumber = try strongSelf.model.getArticle(forRowNumber: number)
                return articleForNumber.description
            } catch NewsListError.emptyArrayOfArticles {
                strongSelf.showAlert(with: "Whoops...", and: "Empty Array")
                return nil
            } catch {
                strongSelf.showAlert(with: "Whoops...", and: "Unexpected Error")
                return nil
            }
        }
    }
}

