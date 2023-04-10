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
  func presentTodoList(response: TodoListProtocol)
  func presentDeleteTodo(response: MainScene.DeleteTodo.Response)
  func presentCheckBoxTap(response: MainScene.ModifyTodo.Response)
}

class MainPresenter: MainPresentationLogic
{
  weak var viewController: MainDisplayLogic?
  
  // MARK: Do something
  
  //인터렉터한테 받은 날것의 데이터를 받음
  
  func presentTodoList(response: TodoListProtocol) {
    typealias DisplayedTodoList = MainScene.FetchTodoList.ViewModel.DisplayedTodo
    
    var displayTodoList: [String: [DisplayedTodoList]] = [:]
    
    guard let responseTodoList = response.todoList else { return }
    
    var sections: [String] = []
    responseTodoList.keys.sorted().forEach { sections.append($0) }
    sections.reverse()
    
    sections.forEach {
      let todoDate = responseTodoList[$0]
      let todoAday = todoDate?.map{
        return DisplayedTodoList(
          id: $0.id ?? 0,
          title: $0.title ?? "",
          isDone: $0.isDone ?? false,
          updatedTime: $0.updatedTime,
          updatedDate: $0.updatedDate
        )
      }
      displayTodoList.updateValue(todoAday!, forKey: $0)
    }
    
    let nowPage = response.page
    let viewModel = MainScene.FetchTodoList.ViewModel(error: response.error as? NetworkError, page: nowPage + 1, displayedTodoList: displayTodoList, sections: sections)
    viewController?.displayTodoList(viewModel: viewModel)
  }
  
  func presentDeleteTodo(response: MainScene.DeleteTodo.Response) {
    guard let indexPath = response.indexPath else {
      return
    }
    
    let viewModel = MainScene.DeleteTodo.ViewModel(indexPath: indexPath, page: response.page, error: response.error as? NetworkError)
    viewController?.displayDeleteTodo(viewModel: viewModel)
  }
  
  func presentCheckBoxTap(response: MainScene.ModifyTodo.Response) {
    typealias DisplayedTodo = MainScene.ModifyTodo.ViewModel.DisplayedTodo

    let displayTodo = DisplayedTodo(
      id: response.todoEntity?.id ?? 0,
      title: response.todoEntity?.title ?? "",
      isDone: response.todoEntity?.isDone ?? false,
      updatedTime: response.todoEntity?.updatedTime ?? "",
      updatedDate: response.todoEntity?.updatedDate ?? ""
    )
    
    let viewModel = MainScene.ModifyTodo.ViewModel(indexPath: response.indexPath, disPlayTodo: displayTodo, page: response.page, error: response.error as? NetworkError)
    
    viewController?.checkDoneTodo(viewModel: viewModel)
  }
}
