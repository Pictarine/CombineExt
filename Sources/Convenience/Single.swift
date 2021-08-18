//
//  Single.swift
//  CombineExt
//
//  Created by Jérémy Touzy on 18/08/2021.
//  Copyright © 2020 Combine Community. All rights reserved.
//

#if canImport(Combine)
import Combine

// ========================================================================
// MARK: Single protocol
// ========================================================================

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol SinglePublisher: Publisher {
}

// ========================================================================
// MARK: AnySinglePublisher for type-erasure
// ========================================================================

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct AnySinglePublisher<Output, Failure: Error>: SinglePublisher {
  public typealias Failure = Failure
  fileprivate let upstream: AnyPublisher<Output, Failure>

  fileprivate init<P>(unchecked publisher: P)
  where P: Publisher, P.Failure == Self.Failure, P.Output == Output {
    self.upstream = publisher.eraseToAnyPublisher()
  }

  public init<P>(_ singlePublisher: P)
  where P: SinglePublisher, P.Failure == Self.Failure, P.Output == Output {
    self.upstream = singlePublisher.eraseToAnyPublisher()
  }

  public func receive<S>(subscriber: S)
  where S: Combine.Subscriber, S.Failure == Self.Failure, S.Input == Output {
    upstream.receive(subscriber: subscriber)
  }
}

// ========================================================================
// MARK: DeferredFuture for deferred single value
// ========================================================================

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias DeferredFuture<Output, Failure: Swift.Error> = Deferred<Future<Output, Failure>>

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension DeferredFuture: SinglePublisher {
  public typealias Builder = (@escaping (Result<Output, Failure>) -> Void) -> Void

  public static func create<Output, Failure>(
    _ builder: @escaping DeferredFuture<Output, Failure>.Builder
  ) -> DeferredFuture<Output, Failure> {
    Deferred<Future<Output, Failure>> {
      Future(builder)
    }
  }
}

// ========================================================================
// MARK: First stream value conformance
// ========================================================================

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.First: SinglePublisher {
  internal func toAnySinglePublisher() -> AnySinglePublisher<Output, Failure> {
    AnySinglePublisher(self)
  }
}

// ========================================================================
// MARK: PassthroughSubject convenience converters
// ========================================================================

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension PassthroughSubject {
  func nextSingleValue() -> AnySinglePublisher<Output, Failure> {
    eraseToAnySinglePublisher()
  }
}

// ========================================================================
// MARK: Publishers utilities
// ========================================================================

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  func eraseToAnySinglePublisher() -> AnySinglePublisher<Output, Failure> {
    first().toAnySinglePublisher()
  }
}
#endif
