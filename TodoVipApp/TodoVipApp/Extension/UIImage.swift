//
//  UIImage.swift
//  TodoVipApp
//
//  Created by song on 2023/04/04.
//

import UIKit

extension UIImage {
  static let theme = ImageTheme()
}

struct ImageTheme {
  let magnifyingglass = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.theme.boardColor!, renderingMode: .alwaysOriginal)
}
