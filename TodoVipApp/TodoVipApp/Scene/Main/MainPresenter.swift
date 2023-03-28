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
  func presentTodoList(response: FetchTodoList.FetchTodoList.Response)
}

class MainPresenter: MainPresentationLogic
{
 
  
  weak var viewController: MainDisplayLogic?
  
  // MARK: Do something
  
  //인터렉터한테 받은 날것의 데이터를 받음
  
  func presentTodoList(response: FetchTodoList.FetchTodoList.Response) {
    typealias DisplayedTodoList = FetchTodoList.FetchTodoList.ViewModel.DisplayedTodo
    
    let displayedTodoList = response.todoList.map { DisplayedTodoList(todoEntity: $0) }
    
    let viewModel = FetchTodoList.FetchTodoList.ViewModel(displayedTodoList: displayedTodoList)
        
    viewController?.displayTodoList(viewModel: viewModel)
  }
}
