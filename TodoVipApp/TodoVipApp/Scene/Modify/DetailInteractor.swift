//
//  DetailInteractor.swift
//  TodoVipApp
//
//  Created by song on 2023/04/02.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailBusinessLogic
{
  func fetchTodo(request: Detail.PresentTodo.Request)
  func modifyTodo(request: Detail.ModifyTodo.Request)
}

protocol DetailDataStore
{
  var todoId: Int? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore
{
  
  var todoId: Int?
  var presenter: DetailPresentationLogic?
  var worker: DetailWorker?
  
  // MARK: Do something
  
  func fetchTodo(request: Detail.PresentTodo.Request)
  {
    worker = DetailWorker()
    Task {
      do {
        let todoEntity = try await worker?.todoUsecase.fetchTodo(id: todoId ?? 0)
        let response = Detail.PresentTodo.Response(todo: todoEntity)
        presenter?.presentTodo(response: response)
      } catch {
        let response = Detail.PresentTodo.Response(error: error)
        presenter?.presentTodo(response: response)
      }
    }
  }
  
  func modifyTodo(request: Detail.ModifyTodo.Request) {
    worker = DetailWorker()
    Task {
      do  {
        let todoEntity = try await worker?.modifyTodo(id: request.id, title: request.title, isDone: request.isDone)
        NotificationCenter.default.post(name: NSNotification.Name("modifyTodo"), object: todoEntity)
        
        
        
        let response = Detail.ModifyTodo.Response(title: todoEntity?.title, isDone: todoEntity?.isDone)
        presenter?.presentModifyResult(response: response)
      } catch {
        let response = Detail.ModifyTodo.Response(error: error)
        presenter?.presentModifyResult(response: response)
      }
    }
  }
}
