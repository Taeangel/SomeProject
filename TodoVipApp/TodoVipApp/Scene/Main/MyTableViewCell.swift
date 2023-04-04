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
    self.contentLabel.text = todo.title
    self.dateLabel.text = "\(todo.updatedDate)"
    
    if todo.isDone == false {
      doneButton.setImage(UIImage(systemName: "square"), for: .normal)
    } else {
      doneButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
      contentLabel.textColor = .gray
      dateLabel.textColor = .gray
    }
  }
}
