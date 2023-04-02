//
//  MainPresenter.swift
//  TodoVipApp
//
//  Created by song on 2023/03/24.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainPresentationLogic

{
  func presentTodoList(response: MainScene.FetchTodoList.Response)
}

class MainPresenter: MainPresentationLogic
{
  
  weak var viewController: MainDisplayLogic?
  
  // MARK: Do something
  
  //인터렉터한테 받은 날것의 데이터를 받음
  
  func presentTodoList(response: MainScene.FetchTodoList.Response) {
    typealias DisplayedTodoList = MainScene.FetchTodoList.ViewModel.DisplayedTodo
    
    let displayedTodoList = response.todoList.map { todoEntity -> DisplayedTodoList in
      
      guard let findDateT = todoEntity.createdAt?.firstIndex(of: "T"),
            let findDateDot = todoEntity.createdAt?.firstIndex(of: ".") else {
        return DisplayedTodoList(id: 0, title: "", isDone: false, createdTime: "", createdDate: "")
      }
      
      guard var createdDate = todoEntity.createdAt?[...findDateT],
            var createdTime = todoEntity.createdAt?[findDateT...findDateDot] else {
        return DisplayedTodoList(id: 0, title: "", isDone: false, createdTime: "", createdDate: "")
      }
      
      createdDate.removeLast()
      createdTime.removeFirst()
      
      return  DisplayedTodoList(
        id: todoEntity.id ?? 1,
        title: todoEntity.title ?? "",
        isDone: todoEntity.isDone ?? false,
        createdTime: "\(createdTime.prefix(5))",
        createdDate: "\(createdDate)"
      )
    }
    
    let viewModel = MainScene.FetchTodoList.ViewModel(displayedTodoList: displayedTodoList)
    
    viewController?.displayTodoList(viewModel: viewModel)
  }
}
