//
//  myTableViewCell.swift
//  TodoVipApp
//
//  Created by song on 2023/03/26.
//

import UIKit

class MyTableViewCell: UITableViewCell {
  typealias Todo = MainScene.FetchTodoList.ViewModel.DisplayedTodo
  
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var todo: Todo?
  
  var onEditAction: ((_ todo: Todo) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    self.doneButton.setImage(UIImage(systemName: "square"), for: .normal)
    self.contentLabel.attributedText = contentLabel.text?.removeAttribute
    self.contentLabel.text = nil
    self.dateLabel.text = nil
    contentLabel.textColor = .black
    dateLabel.textColor = .black
  }
  
  @IBAction func checkBoxDidTap(_ sender: Any) {
    if let todo = self.todo {
      onEditAction?(todo)
    }
  }
  
  func configureCell(todo: MainScene.FetchTodoList.ViewModel.DisplayedTodo)
  {
    self.todo = todo
    self.contentLabel.text = todo.title
    
    guard let time = Int(todo.updatedTime.prefix(2)) else {
      return
    }
    
    if time > 11 {
      self.dateLabel.text = "\(todo.updatedTime) PM"
    } else {
      self.dateLabel.text = "\(todo.updatedTime) AM"
    }
    
    if todo.isDone == false {
      doneButton.setImage(UIImage(systemName: "square"), for: .normal)
      contentLabel.attributedText = contentLabel.text?.removeAttribute
    } else {
      doneButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
      contentLabel.textColor = .gray
      dateLabel.textColor = .gray
      contentLabel.attributedText = contentLabel.text?.strikeString
    }
  }
}

extension String {
  var strikeString: NSAttributedString {
    let attributeString = NSMutableAttributedString(string: self)
    
    attributeString.addAttribute(
      .strikethroughStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSMakeRange(0, attributeString.length))
    
    return attributeString
  }
  
  var removeAttribute: NSAttributedString {
    let attributeString = NSMutableAttributedString(string: self)
    
    attributeString.removeAttribute(
      .strikethroughStyle,
      range: NSMakeRange(0, attributeString.length))
    
    return attributeString
  }
}
