//
//  NewsViewProtocols.swift
//  newsApp
//
//  Created by Niff1e on 12.08.23.
//

import Foundation
import UIKit

protocol NewsViewable {

    var mainView: NewsMainViewable { get }
}

protocol NewsMainViewable: UIView {

    func setDataToCell(titleText: String?, descriptionText: String?)
    func setImageToCell(image: UIImage?)
    func clearAllInfo()
}
