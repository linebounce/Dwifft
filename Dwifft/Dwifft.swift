//
//  LCS.swift
//  Dwifft
//
//  Created by Jack Flintermann on 3/14/15.
//  Copyright (c) 2015 jflinter. All rights reserved.
//

import Foundation

public struct Diff<T> {
    public let results: [DiffStep<T>]
}

// MARK: - Diff Extension

public extension Diff {
    public var insertions: [DiffStep<T>] { return results.filter { $0.isInsertion  }.sorted { $0.idx < $1.idx } }
    public var deletions:  [DiffStep<T>] { return results.filter { !$0.isInsertion }.sorted { $0.idx > $1.idx } }
    
    public var reversed: Diff<T> {
        return Diff<T>(results: results.reversed().map { $0.reversed })
    }
}

public func + <T> (left: Diff<T>, right: DiffStep<T>) -> Diff<T> {
    return Diff<T>(results: left.results + [right])
}
