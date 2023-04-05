//
//  MainViewController.swift
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
import Combine

protocol MainDisplayLogic: AnyObject
{
  func displayTodoList(viewModel: MainScene.FetchTodoList.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic, Alertable
{
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
  
  // MARK: - IBoutlets
  
  // MARK: - Properties
  typealias Displayedtodo = MainScene.FetchTodoList.ViewModel.DisplayedTodo
  private var sections: [String] = []
  private var todoList: [String: [Displayedtodo]] = [:]
  private let refreshControl: UIRefreshControl = UIRefreshControl()
  private var fetchingMore = false
  private var page = 1
  private var cancellables = Set<AnyCancellable>()
  private var searchText = CurrentValueSubject<String, Never>("")
  
  // MARK: Object lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
    
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    configureTableView()
    fetchTodoList()
    configureView()
    addSubscription()
  }
  
  // MARK: - addSubscriptionn
  
  private func addSubscription() {
    searchBar.textPublisher()
      .sink { [weak self] in self?.searchTodos($0)}
      .store(in: &cancellables)
  }
  
  private func searchTodos(_ todo: String) {
    if todo == "" {
      let request = MainScene.FetchTodoList.Request()
      interactor?.fetchTodoList(request: request)
      
    } else {
      let request = MainScene.FetchSearchTodoList.Request(quary: todo)
      interactor?.fetchSearchTodoList(request: request)
    }
  }
  
  // MARK: 인터랙터에게 보내는 메서드
  
  @IBOutlet weak var myTableView: UITableView!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var searchBar: UITextField!
  
  private func configureView() {
    self.view.backgroundColor = UIColor.theme.backgroundColor
    self.searchBar.clipsToBounds = true
    self.searchBar.layer.cornerRadius = 15
    self.searchBar.layer.borderWidth = 1
    self.searchBar.layer.borderColor = UIColor.theme.boardColor?.cgColor
    self.searchBar.addleftimage(image: UIImage.theme.magnifyingglass?.withTintColor(.gray) ?? UIImage())
    
    addButton.setImage(UIImage.theme.largePlusButton, for: .normal)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.didDismissDetailNotification(_:)),
      name: NSNotification.Name("ModalDismissNC"),
      object: nil
    )
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView)
  {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    
    if offsetY > contentHeight - scrollView.frame.height
    {
      if !fetchingMore
      {
        beginBatchFetch()
      }
    }
  }
  
  func beginBatchFetch()
  {
    fetchingMore = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
      self.fetchTodoList()
      self.fetchingMore = false
    })
  }
  
  @objc func didDismissDetailNotification(_ notification: Notification) {
    let fetchRequest = MainScene.FetchTodoList.Request()
    
    self.interactor?.fetchTodoList(request: fetchRequest)
    
  }
  
  func fetchTodoList()
  {
    let request = MainScene.FetchTodoList.Request(page: page)
    interactor?.fetchTodoList(request: request)
  }
  
  func deleteTodo(id: Int) {
    let deleteRequest = MainScene.DeleteTodo.Request(id: id)
    let fetchRequest = MainScene.FetchTodoList.Request()
    interactor?.deleteTodo(request: deleteRequest)
    interactor?.fetchTodoList(request: fetchRequest)
    //매끄럽게 잘안된다
  }
  
  //프리젠터에서 뷰로 화면에 그리는 것
  func displayTodoList(viewModel: MainScene.FetchTodoList.ViewModel) {
    self.page += 1
    self.todoList = viewModel.displayedTodoList
    self.sections = viewModel.sections
    
    //    sections = todoList
    //      .map { $0.updatedDate }
    //      .removeDuplicates()
    //
    //    sectionsNumber = todoList
    //      .map { $0.updatedDate }
    //
    //    sectionInfo = sections.map { standard in
    //      sectionsNumber.filter { target in
    //        standard == target
    //      }.count
    //    }
    
    DispatchQueue.main.async {
      self.myTableView.reloadData()
    }
  }
}

extension MainViewController: UITableViewDelegate
{
  private func configureTableView()
  {
    let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
    self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: "MyTableViewCell")
    self.myTableView.rowHeight = UITableView.automaticDimension
    self.myTableView.estimatedRowHeight = 120
    self.myTableView.delegate = self
    self.myTableView.dataSource = self
    refreshControl.addTarget(self, action: #selector(self.refreshFunction), for: .valueChanged)
    self.myTableView.refreshControl = refreshControl
  }
  
  @objc func refreshFunction() {
    self.page = 1
    let request = MainScene.FetchTodoList.Request(page: 1)
    interactor?.fetchTodoList(request: request)
    refreshControl.endRefreshing()
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
      
      guard let date = self?.sections[indexPath.section] else { return }
      guard let todos = self?.todoList[date] else { return }
      self?.deleteTodo(id: todos[indexPath.row].id)
      
      //      guard let section = indexPath.first else { return }
      //      let row = indexPath.row
      //      let id: Int
      //
      //      if section == 0 {
      //        id = self?.todoList[row].id ?? 0
      //      } else {
      //        var startIndex = 0
      //
      //        for i in 0...indexPath.section - 1 {
      //          startIndex += self?.sectionInfo[i] ?? 0
      //        }
      //        id = self?.todoList[startIndex + row].id ?? 0
      //      }
      //      self?.deleteTodo(id: id)
    }
    
    return UISwipeActionsConfiguration(actions: [delete])
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
  {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = .black
  }
}

extension MainViewController: UITableViewDataSource
{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let date = sections[indexPath.section]
    guard let todos = todoList[date] else { return  }
    
    router?.routeToDetail(todoId: todos[indexPath.row].id)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return sections[section]
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return sectionsNumber.filter { $0 == sections[section] }.count
    guard let sectionsCount = todoList[sections[section]]?.count else {
      return 0
    }
    return sectionsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = myTableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else {
      return UITableViewCell()
    }
    
    let date = sections[indexPath.section]
    guard let todos = todoList[date] else { return cell }
    cell.configureCell(todo: todos[indexPath.row])
    
    return cell
    
    //    if indexPath.section == 0 {
    //      cell.configureCell(todo: todoList[indexPath.row])
    //      return cell
    //    } else {
    //      var startIndex = 0
    //
    //      for i in 0...indexPath.section - 1 {
    //        startIndex += sectionInfo[i]
    //      }
    //
    //      cell.configureCell(todo: todoList[startIndex + indexPath.row])
    //      return cell
    //    }
  }
}

