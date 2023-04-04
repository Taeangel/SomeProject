//
//  UIColor.swift
//  TodoVipApp
//
//  Created by song on 2023/04/04.
//

import Foundation
import UIKit

extension UIColor {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let boardColor = UIColor(named: "boardColor")
  let backgroundColor = UIColor(named: "backgroundColor")
}
