//
//  NetworkDispatcher.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkDispatcher {
  func execute(request: Request) -> Observable<Any>
}


class Task<Input, Output> {
  func perform(_ element: Input) -> Observable<Output> {
    fatalError("This must be implemented in subclasses")
  }
}

class NetworkTask<Input: Request, Output>: Task<Input, Output> {
  let dispatcher: NetworkDispatcher
  
  init(dispatcher: NetworkDispatcher) {
    self.dispatcher = dispatcher
  }
  
  override func perform(_ element: Input) -> Observable<Output> {
    fatalError("This must be implemented in subclasses")
  }
}

class DeezerDispatcher: NSObject, NetworkDispatcher {
  
  func execute(request: Request) -> Observable<Any> {
    return Observable.create { observer in
      let request = Alamofire.request(URL(string: request.path)!).responseJSON { response in
        switch response.result {
        case .success(let value):
          observer.onNext(value)
          observer.onCompleted()
          
        case .failure(let error):
          observer.onError(error)
        }
      }
      
      return Disposables.create(with: request.cancel)
    }
    
  }
  
  
}
