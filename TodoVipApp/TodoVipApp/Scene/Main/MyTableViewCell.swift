//
//  myTableViewCell.swift
//  TodoVipApp
//
//  Created by song on 2023/03/26.
//

import UIKit

class MyTableViewCell: UITableViewCell {
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configureCell(todo: MainScene.FetchTodoList.ViewModel.DisplayedTodo)
  {
    if todo.isDone == false {
      self.contentLabel.text = todo.title
      self.dateLabel.text = "\(todo.createdDate)"
      
    } else {
      
      self.contentLabel.text = todo.title
      contentLabel.textColor = .gray
      self.dateLabel.text = "\(todo.createdDate)"
      dateLabel.textColor = .gray

    }
    
  }
}
