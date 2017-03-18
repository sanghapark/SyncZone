//
//  SyncZone.swift
//  SyncZone
//
//  Created by ParkSangHa on 2017. 3. 18..
//  Copyright © 2017년 sanghapark1021. All rights reserved.
//

import Foundation


class SyncZone {
  
  enum AwaitError: Error {
    case timeout
    case noresult
  }
  
  typealias Completion = (Any?) -> ()
  typealias AwaitBody = (@escaping Completion) -> ()
  typealias Await = ( (AwaitBody) throws -> Any? ) -> ()
  
  typealias CompletionWithError = (Any?, Error?) -> ()
  typealias AwaitBodyWithError = (@escaping CompletionWithError) -> ()
  typealias AwaitWithError = ( (AwaitBodyWithError) throws -> Any? ) -> ()
  
  static let queue = DispatchQueue(label: "com.sanghapark.synczone", attributes: .concurrent)
  
  @discardableResult
  init(on queue: DispatchQueue = SyncZone.queue, body: @escaping Await ) {
    queue.async {
      body(self.await)
    }
  }
  
  func await (body: AwaitBody ) throws -> Any? {
    let semapahore = DispatchSemaphore(value: 0)
    var result: Any? {
      didSet {
        semapahore.signal()
      }
    }
    
    body { ret in
      result = ret
    }
    
    if semapahore.wait(timeout: .now() + 100) == .timedOut {
      throw AwaitError.timeout
    }
    
    if result == nil {
      throw AwaitError.noresult
    }
    return result
  }
  
  
}
