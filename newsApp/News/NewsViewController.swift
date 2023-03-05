//
//  NewsViewController.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsViewController: UIViewController {

    // MARK: - Private Properties

    private let model = NewsModel()
    private let newsView = NewsView()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        view = newsView
    }
}
