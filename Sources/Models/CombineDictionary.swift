//
//  CombineDictionary.swift
//  CombineExt
//
//  Created by Jérémy Touzy on 18/08/2021.
//  Copyright © 2020 Combine Community. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CombineDictionary<Key: Hashable, Value> {
  private let storage: CurrentValueRelay<[Key: Value]>
  private let lock = NSRecursiveLock()

  public var items: AnyPublisher<[Key: Value], Never> {
    storage.eraseToAnyPublisher()
  }
  public var count: AnyPublisher<Int, Never> {
    storage
      .map(\.count)
      .eraseToAnyPublisher()
  }

  public init(elements: [Key: Value] = [:]) {
    storage = CurrentValueRelay(elements)
  }
  public func setValue(_ value: Value?, forKey key: Key) {
    lock.lock()
    defer {
      lock.unlock()
    }
    var copy = storage.value
    copy[key] = value
    storage.accept(copy)
  }
  public func valueForKey(_ key: Key) -> Value? {
    lock.lock()
    defer {
      lock.unlock()
    }
    return storage.value[key]
  }
  public func removeValueForKey(key: Key) {
    lock.lock()
    defer {
      lock.unlock()
    }
    var copy = storage.value
    copy[key] = .none
    storage.accept(copy)
  }
  public func first(
    where predicate: @escaping ((key: Key, value: Value)) -> Bool
  ) -> (key: Key, value: Value)? {
    lock.lock()
    defer {
      lock.unlock()
    }
    return storage.value.first(where: predicate)
  }
}
#endif
