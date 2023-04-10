//
//  AlertBuilder.swift
//  TodoVipApp
//
//  Created by song on 2023/04/04.
//

import Foundation
import UIKit

protocol Alertable: UIViewController {}

extension Alertable {
  func showErrorAlertWithConfirmButton(_ message: String) {
    AlertBuilder.init(viewController: self)
      .addAction(title: "확인", style: .default)
      .show(title: "오류", message: message, style: .alert)
  }
  
  func showSuccessAlertWithConfirmButton(_ message: String, action: (() -> Void)? = nil) {
    AlertBuilder.init(viewController: self)
      .addAction(title: "확인", style: .default, action: action)
      .show(title: "성공", message: message, style: .alert)
  }
}

struct AlertAction {
  let title: String
  let style: UIAlertAction.Style
  let completionHandler: (() -> Void)?
}

final class AlertBuilder {
  private var actions: [AlertAction] = []
  private weak var viewController: UIViewController?
  
  init(viewController: UIViewController?) {
    self.viewController = viewController
  }
  
  func setViewController(to viewController: UIViewController?) -> Self {
    self.viewController = viewController
    return self
  }
  
  func addAction(title: String, style: UIAlertAction.Style, action: (() -> Void)? = nil) -> Self {
    actions.append(AlertAction(title: title, style: style, completionHandler: action))
    return self
  }
  
  func show(title: String? = nil, message: String? = nil, style: UIAlertController.Style) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    
    actions.forEach { action in
      let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
        action.completionHandler?()
      }
      alertController.addAction(alertAction)
    }
    
    viewController?.present(alertController, animated: true)
  }
}
