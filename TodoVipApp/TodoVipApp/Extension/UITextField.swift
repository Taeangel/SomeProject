//
//  UITextField.swift
//  TodoVipApp
//
//  Created by song on 2023/04/04.
//

import UIKit
import Combine

extension UITextField {
  
  func addleftimage(image: UIImage) {
    let leftView = UIView(frame: CGRectMake(0, 0, 20, 20))
    let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    
    leftimage.image = image
    leftView.addSubview(leftimage)
    self.leftView = leftView
    self.leftViewMode = .always
  }
}

extension UITextField {
  func textPublisher() -> AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .map { ($0.object as? UITextField)?.text  ?? "" }
      .eraseToAnyPublisher()
  }
}
