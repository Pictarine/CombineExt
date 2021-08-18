//
//  AnyCancellable.swift
//  CombineExt
//
//  Created by Jérémy Touzy on 18/08/2021.
//  Copyright © 2020 Combine Community. All rights reserved.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyCancellable {
  static var empty: AnyCancellable {
    AnyCancellable { }
  }
}
#endif
