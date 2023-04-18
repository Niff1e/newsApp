//
//  File.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsListView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Private Properties
    
    private var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var numberOfRows: Int = 0
    
    // MARK: - Internal Properties
    
    var creationOfNewsVC: ((_ number: Int) -> Void)?
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((_ number: Int) -> String?)?
    var textForDescriptionLabel: ((_ number: Int) -> String?)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTableView()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell {
            cell.accessoryType = .disclosureIndicator

            cell.setDataToCell(titleText: textForTitleLabel?(indexPath.row), descrText: textForDescriptionLabel?(indexPath.row))
            pictureToCell?(indexPath.row, { [weak self] img in
                guard let strongSelf = self else { return }
                let tableViewCell = strongSelf.newsTableView.cellForRow(at: indexPath)
                (tableViewCell as? NewsTableViewCell)?.setImageToCell(image: img)
            })
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

    
    
    // MARK: - Private Functions
    
    private func setupTableView() {
        self.addSubview(newsTableView)
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        
        NSLayoutConstraint.activate([
            newsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // MARK: - Internal Functions
    
    func setNumberOfRows(number: Int) {
        self.numberOfRows = number
        newsTableView.reloadData()
    }
}
