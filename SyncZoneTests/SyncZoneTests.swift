//
//  SyncZoneTests.swift
//  SyncZoneTests
//
//  Created by ParkSangHa on 2017. 3. 18..
//  Copyright © 2017년 sanghapark1021. All rights reserved.
//

import XCTest
@testable import SyncZone

struct User {
  var id: String
  var name: String
}

class SyncZoneTests: XCTestCase {
  
  var avatar: String?
  var syncZoneCalled: Bool = false
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.avatar = nil
    self.syncZoneCalled = false
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    
    let asyncExpectation = expectation(description: "SyncZone awaiting")
    
    SyncZone { await in
      
      XCTAssertNotEqual(Thread.current.description, "com.sanghapark.synczone", "must be equal")
      
      self.syncZoneCalled = true
      do {
        let user = try await { resolve in self.login(id: "plasticono", pw: "123") { resolve($0) } } as! User
        let avatar = try await { resolve in self.getAvatar(user: user) { resolve($0) } } as! String
        self.avatar = avatar
        asyncExpectation.fulfill()
      } catch {
      }
    }
    
    XCTAssertFalse(self.syncZoneCalled, "SyncZone must not be called yet.")
    
    self.waitForExpectations(timeout: 5) { error in
      XCTAssertEqual(self.avatar, "https://www.plasticono.com", "it should be https://www.plasticono.com")
    }

  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  
  func login(id: String, pw: String, completion: @escaping (User?) -> ()) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
      completion(User(id: "plasticono", name: "parksangha"))
    }
  }
  
  func getAvatar(user: User, completion: @escaping (String?) -> ()) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [user] in
      completion("https://www.\(user.id).com")
    }
  }
}
