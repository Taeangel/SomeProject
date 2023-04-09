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
import CombineCocoa

protocol MainDisplayLogic: AnyObject
{
  func displayTodoList(viewModel: MainScene.FetchTodoList.ViewModel)
  
  func deleteTodo(viewModel: MainScene.DeleteTodo.ViewModel)
  func checkDoneTodo(viewModel: MainScene.CheckBoxTodo.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic, Alertable
{
  
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
  
  // MARK: - IBoutlets
  
  // MARK: - Properties
  typealias Displayedtodo = MainScene.FetchTodoList.ViewModel.DisplayedTodo
  private let refreshControl: UIRefreshControl = UIRefreshControl()
  private var sections: [String] = []
  private var todoList: [String: [Displayedtodo]] = [:]
  private var page = 1
  private var cancellables = Set<AnyCancellable>()
  @Published private var searchText = ""
  @Published private var isloadig: Bool = false
  @Published private var fetchingMore = true
  
  lazy var isTableBottom: AnyPublisher<Bool, Never> = myTableView
    .contentOffsetPublisher
    .map { offset -> Bool in
      let height = self.myTableView.frame.size.height
      let contentTOffset = offset.y
      let distanceFromBottom = self.myTableView.contentSize.height - contentTOffset
      return distanceFromBottom - 200 < height
    }
    .eraseToAnyPublisher()
  
  
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
  
  // MARK: - @IBOutlets
  
  @IBOutlet weak var myTableView: UITableView!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var searchBar: UITextField!
  
  // MARK: - addSubscriptionn
  
  private func addSubscription() {
    searchBar.textPublisher()
      .sink { [weak self] in self?.searchTodos($0)}
      .store(in: &cancellables)
    
//    Publishers.CombineLatest(isTableBottom, $fetchingMore)
//      .map {
//        print("isTableBottom\($0)")
//        print("fetchingMore\($1)")
//        return $0 == true && $1 == true }
//      .sink { [weak self] in
//        if $0 {
//          print("바닥이야. ")
//          self?.beginBatchFetch()
//        }
//      }
//      .store(in: &cancellables)
    
    
    myTableView.contentOffsetPublisher
      .sink { [weak self] offset in
        guard let self = self else { return }
        let offsetY = offset.y
        let contentHeight = self.myTableView.contentSize.height

        if offsetY > contentHeight - self.myTableView.frame.height {
          if self.fetchingMore {
            print("시작할떄 불리는가")
            self.beginBatchFetch()
          }
        }
      }
      .store(in: &cancellables)
  }
  
  // MARK: 인터랙터에게 보내는 메서드
  
  private func searchTodos(_ todo: String) {
    if todo == "" {
      let request = MainScene.FetchTodoList.Request()
      interactor?.fetchTodoList(request: request)
      
    } else {
      let request = MainScene.FetchSearchTodoList.Request(quary: todo)
      interactor?.fetchSearchTodoList(request: request)
    }
  }
  
  func beginBatchFetch() {
      self.fetchTodoList()
  }
  
  @objc func didDismissDetailNotification(_ notification: Notification) {
    let fetchRequest = MainScene.FetchTodoList.Request()
    self.interactor?.fetchTodoList(request: fetchRequest)
  }
  
  func fetchTodoList() {
    let request = MainScene.FetchTodoList.Request(page: page)
    interactor?.fetchTodoList(request: request)
  }
  
  func deleteTodo(id: Int) {
    let deleteRequest = MainScene.DeleteTodo.Request(id: id)
    interactor?.deleteTodo(request: deleteRequest)
  }
  
  @IBAction func presentModal(_ sender: Any) {
    router?.presentModalAdd()
  }
  
  // MARK: - 프리젠터에서 뷰로 보내진

  func displayTodoList(viewModel: MainScene.FetchTodoList.ViewModel) {
    
    guard let error = viewModel.error else {
      // 에러 있음
      self.page += viewModel.page
      self.todoList = viewModel.displayedTodoList
      self.sections = viewModel.sections
      self.fetchingMore = true
      
      DispatchQueue.main.async {
        self.myTableView.reloadData()
      }
      
      return
    }
  // 에러 없음
   
    DispatchQueue.main.async {
      self.showErrorAlertWithConfirmButton(error.errorDescription ?? "")
    }
  }
  
  func deleteTodo(viewModel: MainScene.DeleteTodo.ViewModel) {
    guard let error = viewModel.error else {
      self.page = viewModel.page
//      fetchTodoList()
//      let indexPath = IndexPath()
//      indexPath.row = 0
//      indexPath.section = 1
//      tableView(myTableView, commit: .delete, forRowAt: indexPath)
      
      return
    }
    
    DispatchQueue.main.async {
      self.showErrorAlertWithConfirmButton(error.errorDescription ?? "")
    }
  }
  
  func checkDoneTodo(viewModel: MainScene.CheckBoxTodo.ViewModel) {
    guard let error = viewModel.error else {
      self.page = viewModel.page
      fetchTodoList()
      return
    }
    
    DispatchQueue.main.async {
      self.showErrorAlertWithConfirmButton(error.errorDescription ?? "")
    }
  }
}

// MARK: - TableView

extension MainViewController: UITableViewDelegate
{
  @objc func refreshFunction() {
    self.page = 1
    let request = MainScene.FetchTodoList.Request(page: self.page)
    interactor?.fetchTodoList(request: request)
    refreshControl.endRefreshing()
  }
  
//  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//    .delete
//  }
//
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//      DispatchQueue.main.async {
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//      }
//
//    }
//  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
      
      guard let data = self?.sections[indexPath.section] else { return }
      guard let todos = self?.todoList[data] else { return }
      
      self?.todoList[data]?.remove(at: indexPath.row)
      
      DispatchQueue.main.async {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
      
      self?.deleteTodo(id: todos[indexPath.row].id)
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
    
    cell.onEditAction = { [weak self] clickedTodo in
     
      let idDone = !clickedTodo.isDone
      let request = MainScene.CheckBoxTodo.Request(id: clickedTodo.id, title: clickedTodo.title, isDone: idDone)
      self?.interactor?.checkTodo(request: request)
    }
    
    return cell
  }
}

