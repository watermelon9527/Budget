//
//  UIImageExtension.swift
//  Budget
//
//  Created by nono chan  on 2020/12/31.
//

import Foundation
import UIKit
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
