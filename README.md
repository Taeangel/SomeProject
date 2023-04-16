# VIPTodoProject

![스크린샷 2023-04-16 오전 9 48 36](https://user-images.githubusercontent.com/94357519/232337967-f90affb0-50e0-44ea-84fd-5ea5c4652717.png)

## 프로젝트 기술

### Clean Swift(VIP)

VIP아키텍쳐의 장점
- DisplayLogic BusinessLogic PresentationLogic을 각각 분리할 수 있다
- 각각의 flow를 control을 할 수 있다

VIP아키텍쳐의 단점
- 파일갯수가 너무 많고 러닝커브가 존재한다.
- 간단한 로직도 View에서 Interactor로보내고 Interactor에서 Presenter로 보내고 Presenter로에서 다시 View로 보내야한다

<img src="https://user-images.githubusercontent.com/94357519/232338002-9a88b336-5301-4f62-8178-e3bc02a6c846.png" width="400" height="400"> <img src="https://user-images.githubusercontent.com/94357519/232338046-8ecd1adf-3c54-4de5-9df8-b996d5543ff9.png" width="400" height="400">

<img src="https://user-images.githubusercontent.com/94357519/232338099-4cf8b766-5ad4-4a01-aab9-13d09e7cf28b.png" width="400" height="400"> <img src="https://user-images.githubusercontent.com/94357519/232338327-27b2de13-6d89-448a-8989-1f9a50fe63c9.png" width="400" height="400">


참고 사이트 
`https://www.youtube.com/watch?v=Szlgqnk6gHg`
`https://github.com/Clean-Swift/CleanStore`
`https://clean-swift.com/`

## domain data presentation 분리
Layers
---
- Domain Layer = Entities + Use Cases + Repositories Interfaces
- Data Repositories Layer = Repositories Implementations + API (Network) + Persistence DB
- Presentation Layer (VIP) = View Interactor Presenter

<img src="https://user-images.githubusercontent.com/94357519/232339724-52af9720-7fcb-408e-ad1c-02f3a9814a4b.png" width="200" height="300">

<img src="https://user-images.githubusercontent.com/94357519/232339345-7cc1e861-dfa4-402d-a15f-98babd0e8984.png" width="1000" height="300">

참고 사이트 `https://github.com/kudoleh/iOS-Clean-Architecture-MVVM`

### combine과 combineCocoa를 활용한 리엑티브 프로그래밍
```swift
 $isloading.sink { [weak self] in
      guard let self = self else { return }
      self.myTableView.tableFooterView = $0 ? self.bottomIndicator : nil
    }
    .store(in: &cancellables)
    
    searchBar.textPublisher()
      .delay(for: 1, scheduler: DispatchQueue.main)
      .sink { [weak self] in
        guard let self = self else { return }
        self.page = 1
        self.searchTodos($0)
      }
      .store(in: &cancellables)
    
    myTableView.reachedBottomPublisher().combineLatest(searchBar.textPublisher)
      .delay(for: 0.5, scheduler: DispatchQueue.main)
      .sink {[weak self] in
        guard let self = self else { return }
        if self.fetchingMore {
          self.searchTodos($1 ?? "")
        }
      }
      .store(in: &cancellables)
    
    myTableView.willDisplayHeaderViewPublisher.sink { headerView, sesction in
        let header = headerView as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .black
      }
      .store(in: &cancellables)
    
    myTableView.didSelectRowPublisher
      .sink { [weak self] indexPath in
        guard let self = self else { return }
        let date = self.sections[indexPath.section]
        guard let todos = self.todoList[date] else { return  }
        self.router?.routeToDetail(todoId: todos[indexPath.row].id)
      }
      .store(in: &cancellables)
```
### async await를 사용한 비동기 메서드 처리

- 기존의 방식인 컴플리션 Hendler를 사용하는 방법대신 async await를 사용하여 코드의 가독성을 높임

```swift
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListDTO {
    let data = try await todoApiManager.requestData(.getSearchTodos(page: page, query: query, perPage: perPage))
    
    if data.count == 0 {
      throw NetworkError.noContent
    }
    
    do {
      return try JSONDecoder().decode(TodoListDTO.self, from: data)
    } catch {
      throw NetworkError.decoding
    }
  }
```

```swift
  func fetchTodoList(request: FetchListRequestProtocol) {
    worker = MainWorker(reauestable: session)
    Task{
      do {
        // 데이터를 불러오기
        var todoList: TodoListEntity?
        
        todoList = try await extractedFunc(request: request)
        
        guard let meta = todoList?.meta else { return }
        
        // 데이터를 저장하기
        
        if request.page == 1 {
          self.storedTodoList = todoList?.todoEntity ?? []
          self.todoList = Dictionary(grouping: self.storedTodoList ) { $0.updatedDate }
        } else {
          self.storedTodoList += todoList?.todoEntity ?? []
          self.todoList = Dictionary(grouping: self.storedTodoList ) { $0.updatedDate }
        }

        self.todoList.keys.sorted().forEach { sections.append($0) }
        sections.reverse()
        
        // 데이터를 보내주기
        let response = MainScene.FetchTodoList.Response(todoList: self.todoList, page: meta.currentPage ?? 1, isFetch: meta.isfetch)
        presenter?.presentTodoList(response: response)
      } catch {
        // 데이터를. 보내주기
        let response = MainScene.FetchTodoList.Response(error: error as? NetworkError, page: request.page)
        presenter?.presentTodoList(response: response)
      }
    }
  }

```

트러블 슈팅
