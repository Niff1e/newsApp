//
//  File.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class MainTableView: UITableView, UITableViewDataSource, UITableViewDelegate, NewsListMainViewable {

    // MARK: Private Properties

    private var numberOfRows: Int = 0

    // MARK: - Internal Properties

    var getMoreArticles: (() -> Void)?
    var creationOfNewsVC: ((_ number: Int) -> Void)?
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((_ number: Int) -> String?)?
    var textForDescriptionLabel: ((_ number: Int) -> String?)?

    // MARK: - Init

    init() {
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = .white
        self.dataSource = self
        self.delegate = self
        self.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                        for: indexPath) as? NewsTableViewCell {
            cell.mainView.setDataToCell(titleText: textForTitleLabel?(indexPath.row),
                                        descriptionText: textForDescriptionLabel?(indexPath.row))
            pictureToCell?(indexPath.row) { [weak self] img in
                guard let strongSelf = self else { return }
                let tableViewCell = strongSelf.cellForRow(at: indexPath)
                (tableViewCell as? NewsTableViewCell)?.mainView.setImageToCell(image: img)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }

    // MARK: - Table View Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        creationOfNewsVC?(indexPath.row)
        self.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfRows - 1 {
            getMoreArticles?()
        }
    }

    // MARK: - Internal Functions

    func setNumberOfRows(number: Int) {
        self.numberOfRows = number
        self.reloadData()
    }
}
