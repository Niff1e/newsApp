//
//  NewsListViewProtocols.swift
//  newsApp
//
//  Created by Niff1e on 28.06.23.
//

import Foundation
import UIKit

protocol NewsListViewable: UIView {

    var mainView: NewsListMainViewable { get }

    func isNoResultLabelVisible(isVisible: Bool)
    func isSpinnerAnimated(isAnimated: Bool)
}

protocol NewsListMainViewable: UIView {

    var getMoreArticles: (() -> Void)? { get set }
    var creationOfNewsVC: ((_ number: Int) -> Void)? { get set }
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)? { get set }
    var textForTitleLabel: ((_ number: Int) -> String?)? { get set }
    var textForDescriptionLabel: ((_ number: Int) -> String?)? { get set }

    func setNumberOfRows(number: Int)
}
