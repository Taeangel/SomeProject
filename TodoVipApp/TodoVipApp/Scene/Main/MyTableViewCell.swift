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

  
  func configureCell(post: PostList.FetchList.ViewModel.DisplayedPost)
  {
    self.contentLabel.text = post.title
    self.dateLabel.text = post.content
  }
}
