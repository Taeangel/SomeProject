//
//  MainViewControllerTests.swift
//  TodoVipApp
//
//  Created by song on 2023/04/11.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import TodoVipApp
import XCTest

class MainViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: MainViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupMainViewController()
    self.displayTodoListMockData = [
      "2023-04-10": [DisplayedTodoList(id: 1,
                                       title: "첫번째",
                                       isDone: false,
                                       updatedTime: "08:51",
                                       updatedDate: "2023-04-10"),
                     DisplayedTodoList(id: 2,
                                       title: "두번째",
                                       isDone: false,
                                       updatedTime: "08:50",
                                       updatedDate: "2023-04-10")],
      "2023-04-11": [DisplayedTodoList(id: 3,
                                       title: "세번째",
                                       isDone: false,
                                       updatedTime: "08:50",
                                       updatedDate: "2023-04-11")],
      "2023-04-12": [DisplayedTodoList(id: 4,
                                       title: "네번째",
                                       isDone: false,
                                       updatedTime: "08:50",
                                       updatedDate: "2023-04-12")]
    ]
    self.mockSection = ["2023-04-10", "2023-04-11", "2023-04-12"]
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: mockData
  typealias DisplayedTodoList = MainScene.FetchTodoList.ViewModel.DisplayedTodo
  var displayTodoListMockData: [String: [DisplayedTodoList]] = [:]
  var mockSection: [String] = []
  
  var mockModifyedTodoEntity = TodoEntity(id: 1,
                                          title: "원래는첫번째였습니다.",
                                          isDone: false,
                                          updateAt: "2023-04-10T12:31:05.000000Z")
  // MARK: Test setup
  
  func setupMainViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class MainBusinessLogicSpy: MainBusinessLogic {
    var fetchTodoListCalled = false
    var deleteTodoCalled = false
    var fetchSearchTodoListCalled = false
    var modifyTodoCalled = false
    
    func fetchTodoList(request: MainScene.FetchTodoList.Request) {
      fetchTodoListCalled = true
    }
    func deleteTodo(request: MainScene.DeleteTodo.Request) {
      deleteTodoCalled = true
    }
    func fetchSearchTodoList(request: MainScene.FetchSearchTodoList.Request) {
      fetchSearchTodoListCalled = true
    }
    func modifyTodo(request: MainScene.ModifyTodo.Request) {
      modifyTodoCalled = true
    }
  }
  
  // MARK: Tests
  
  func test_시작할때fetchTodoList메서드가불리는지() {
    // Given
    let spy = MainBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    
    // Then
    XCTAssertTrue(spy.fetchTodoListCalled)
  }
  
  func test_시작할때presenter로부터데이터를제대로받는지() {
    // Given
    let viewModel = MainScene.FetchTodoList.ViewModel(page: 1, displayedTodoList: displayTodoListMockData, sections: mockSection)
    
    // When
    loadView()
    sut.displayTodoList(viewModel: viewModel)
    
    // Then
    XCTAssertEqual(sut.sections.count, self.mockSection.count)
    XCTAssertEqual(sut.todoList.count, self.displayTodoListMockData.count)
    XCTAssertEqual(sut.todoList[self.mockSection.first!]?.count, self.displayTodoListMockData[self.mockSection.first!]?.count)
  }
  
  func test_새로고침할때fetchTodoList메서드가불리는지() {
    // Given
    let spy = MainBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    sut.refreshFunction()
    // Then
    XCTAssertTrue(spy.fetchTodoListCalled)
  }
  
  func test_새로고침할때presenter로부터데이터를제대로받는지() {
    // Given
    let viewModel = MainScene.FetchTodoList.ViewModel(page: 1, displayedTodoList: displayTodoListMockData, sections: mockSection)
    
    // When
    loadView()
    sut.displayTodoList(viewModel: viewModel)
    
    // Then
    XCTAssertEqual(sut.sections.count, self.mockSection.count)
    XCTAssertEqual(sut.todoList.count, self.displayTodoListMockData.count)
    XCTAssertEqual(sut.todoList[self.mockSection.first!]?.count, self.displayTodoListMockData[self.mockSection.first!]?.count)
  }
  
  func test_삭제버튼을눌렀을때deleteTodo메서드가호출되는지() {
    // Given
    let spy = MainBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    sut.deleteTodo(id: 1)
    // Then
    XCTAssertTrue(spy.deleteTodoCalled)
  }
  
  func test_삭제를하고presenter로부터데이터를제대로받는지() {
    // Given
    let mockIndex = IndexPath(row: 0, section: 0)
    let viewModel = MainScene.DeleteTodo.ViewModel(indexPath: mockIndex)
    sut.sections = mockSection
    sut.todoList = displayTodoListMockData

    // When
    loadView()
    sut.myTableView.reloadData()
    sut.displayedDeleteTodo(viewModel: viewModel)

    // Then
//    let section = mockSection[mockIndex.section]
//    displayTodoListMockData[section]?.remove(at: mockIndex.row)
    
    XCTAssertEqual(sut.myTableView.visibleCells.count, 3) // TableView로 테스트하려면 에러가 발생함 데이터는 정확히 들어오는 것같은데 
  }
  
  func test_변경버튼을눌렀을떄modifyTodo메서드가호출되는지() {
    // Given
    let spy = MainBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    sut.modifyTodo(id: 1, title: "", isDone: false)
    // Then
    XCTAssertTrue(spy.modifyTodoCalled)
  }
  
  func test_수정를하고presenter로부터데이터를제대로받는지() {
    // Given
    let mockIndex = IndexPath(row: 1, section: 0)
    typealias DisplayedTodo = MainScene.ModifyTodo.ViewModel.DisplayedTodo

    let mockDisplayedTodo = DisplayedTodo(
      id: mockModifyedTodoEntity.id!,
      title: mockModifyedTodoEntity.title!,
      isDone: mockModifyedTodoEntity.isDone!,
      updatedTime: mockModifyedTodoEntity.updatedTime,
      updatedDate: mockModifyedTodoEntity.updatedDate)

    let viewModel = MainScene.ModifyTodo.ViewModel(indexPath: mockIndex,
                                                   disPlayTodo: mockDisplayedTodo)
    sut.sections = mockSection
    sut.todoList = displayTodoListMockData
    
    // When
    loadView()
    sut.myTableView.reloadData()
    sut.displayedModifyTodo(viewModel: viewModel)

    // Then
  
    let testCell = sut.myTableView.visibleCells[mockIndex.row] as! MyTableViewCell
    
    XCTAssertEqual(testCell.contentLabel.text, viewModel.disPlayTodo?.title, "화면에 리로드 된 쎌의 contentLabel의 타이틀이랑 수정된 displayTodo의 타이틀이 같다")
  }
}
