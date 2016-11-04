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
    
    public func reversed() -> Diff<T> {
        let reversedResults = self.results.reversed().map { (result: DiffStep<T>) -> DiffStep<T> in
            switch result {
            case .insert(let i, let j): return .delete(i, j)
            case .delete(let i, let j): return .insert(i, j)
            }
        }
        return Diff<T>(results: reversedResults)
    }
}

public func + <T> (left: Diff<T>, right: DiffStep<T>) -> Diff<T> {
    return Diff<T>(results: left.results + [right])
}
