//
//  InternetManagerProtocol.swift
//  InternetManager
//
//  Created by Pavel Maal on 17.11.23.
//

import Foundation
import UIKit

public protocol InternetManagerProtocol {
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void)
    func getData(with url: URL?, completion: @escaping (Data?) -> Void)
}
