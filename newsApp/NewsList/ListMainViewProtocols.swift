//
//  ListMainViewProtocols.swift
//  newsApp
//
//  Created by Niff1e on 12.08.23.
//

import Foundation
import UIKit

protocol NewsListViewCellable {

    var mainView: NewsListMainViewCellable { get }
}

protocol NewsListMainViewCellable: UIView {

    func setDataToCell(titleText: String?, descriptionText: String?)
    func setImageToCell(image: UIImage?)
    func clearAllInfo()
}
