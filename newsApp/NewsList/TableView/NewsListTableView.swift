//
//  File.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsListTableView: UIView, UITableViewDataSource, UITableViewDelegate {

    // MARK: Private Properties

    private var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var bottomConstraintOfTableView = CGFloat()
    private var noResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("no_results_label", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.isHidden = true
        return label
    }()

    private var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .black
        indicator.style = .large
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()

    private var numberOfRows: Int = 0

    // MARK: - Internal Properties

    var getMoreArticles: (() -> Void)?
    var creationOfNewsVC: ((_ number: Int) -> Void)?
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((_ number: Int) -> String?)?
    var textForDescriptionLabel: ((_ number: Int) -> String?)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTableView()
        registerNotifications()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(numberOfRows)
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell",
                                                        for: indexPath) as? NewsTableViewCell {
            cell.accessoryType = .disclosureIndicator
            cell.setDataToCell(titleText: textForTitleLabel?(indexPath.row),
                               descrText: textForDescriptionLabel?(indexPath.row))
            pictureToCell?(indexPath.row) { [weak self] img in
                guard let strongSelf = self else { return }
                let tableViewCell = strongSelf.newsTableView.cellForRow(at: indexPath)
                (tableViewCell as? NewsTableViewCell)?.setImageToCell(image: img)
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
        newsTableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfRows - 1 {
            getMoreArticles?()
        }
    }

    // MARK: - Private Functions

    private func setupTableView() {
        self.addSubview(newsTableView)
        newsTableView.backgroundView = noResultLabel
        self.addSubview(indicator)
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")

        NSLayoutConstraint.activate([
            newsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: bottomConstraintOfTableView),
            newsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            noResultLabel.centerXAnchor.constraint(equalTo: newsTableView.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: newsTableView.centerYAnchor),
            noResultLabel.widthAnchor.constraint(equalTo: newsTableView.widthAnchor),
            noResultLabel.heightAnchor.constraint(equalToConstant: 50.0),

            indicator.centerXAnchor.constraint(equalTo: newsTableView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: newsTableView.centerYAnchor)
        ])
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Internal Functions

    func setNumberOfRows(number: Int) {
        self.numberOfRows = number
        newsTableView.reloadData()
    }

    func isNoResultLabelVisible(isVisible: Bool) {
        if isVisible {
            noResultLabel.isHidden = false
        } else {
            noResultLabel.isHidden = true
        }
    }

    func isSpinnerAnimated(isAnimated: Bool) {
        if isAnimated {
            self.newsTableView.isUserInteractionEnabled = false
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        } else {
            self.newsTableView.isUserInteractionEnabled = true
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }

    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else { return }
        let cgRectValue = keyboardFrameSize.cgRectValue
        self.frame.origin.y -= cgRectValue.height
    }

    @objc private func keyboardWillHide() {
        self.frame.origin.y = .zero
    }
}
