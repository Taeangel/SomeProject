//
//  ModifyInteractorTests.swift
//  TodoVipApp
//
//  Created by song on 2023/05/07.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import TodoVipApp
import XCTest

class ModifyInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: ModifyInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupModifyInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupModifyInteractor()
  {
    sut = ModifyInteractor()
  }
  
  // MARK: Test doubles
  
  class ModifyPresentationLogicSpy: ModifyPresentationLogic
  {
    var presentSomethingCalled = false
    
    func presentSomething(response: Modify.Something.Response)
    {
      presentSomethingCalled = true
    }
  }
  
  // MARK: Tests
  
  func testDoSomething()
  {
    // Given
    let spy = ModifyPresentationLogicSpy()
    sut.presenter = spy
    let request = Modify.Something.Request()
    
    // When
    sut.doSomething(request: request)
    
    // Then
    XCTAssertTrue(spy.presentSomethingCalled, "doSomething(request:) should ask the presenter to format the result")
  }
}
