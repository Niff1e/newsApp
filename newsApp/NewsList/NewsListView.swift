//
//  NewsListView.swift
//  newsApp
//
//  Created by Niff1e on 11.07.23.
//

import Foundation
import UIKit

final class NewsListView: UIView, NewsListViewable {

    // MARK: Private Properties

    private(set) var mainView: NewsListMainViewable

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

    // MARK: - Init

    init(view: NewsListMainViewable) {
        self.mainView = view
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Private Functions

    private func setupView() {
        self.addSubview(mainView)
        self.addSubview(noResultLabel)
        self.addSubview(indicator)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            noResultLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            noResultLabel.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),

            indicator.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    // MARK: - Internal Functions

    func isNoResultLabelVisible(isVisible: Bool) {
        if isVisible {
            noResultLabel.isHidden = false
        } else {
            noResultLabel.isHidden = true
        }
    }

    func isSpinnerAnimated(isAnimated: Bool) {
        if isAnimated {
            self.mainView.isUserInteractionEnabled = false
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        } else {
            self.mainView.isUserInteractionEnabled = true
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
