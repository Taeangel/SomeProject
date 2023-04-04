//
//  UITextField.swift
//  TodoVipApp
//
//  Created by song on 2023/04/04.
//

import Foundation
import UIKit

extension UITextField {
  
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
  func addleftimage(image:UIImage) {
    let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    leftimage.image = image
    self.leftView = leftimage
    self.leftViewMode = .always
  }
}
