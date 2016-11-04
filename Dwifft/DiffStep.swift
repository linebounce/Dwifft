//
//  DiffStep.swift
//  Dwifft
//
//  Created by Key Hoffman on 11/4/16.
//  Copyright © 2016 jflinter. All rights reserved.
//

import Foundation

/// These get returned from calls to Array.diff(). They represent insertions or deletions that need to happen to transform array a into array b.
public enum DiffStep<T>: CustomDebugStringConvertible {
    case insert(Int, T)
    case delete(Int, T)
    
    
    public var idx: Int {
        switch self {
        case .insert(let i, _): return i
        case .delete(let i, _): return i
        }
    }
    
    public var value: T {
        switch self {
        case .insert(let j): return j.1
        case .delete(let j): return j.1
        }
    }
    
    internal var isInsertion: Bool {
        switch self {
        case .insert: return true
        case .delete: return false
        }
    }
    
    internal var reversed: DiffStep<T> {
        switch self {
        case let .insert(i, j): return .delete(i, j)
        case let .delete(i, j): return .insert(i, j)
        }
    }
}

// MARK: - CustomDebugStringConvertible Conformance

extension DiffStep {
    public var debugDescription: String {
        switch self {
        case .insert(let i, let j): return "+\(j)@\(i)"
        case .delete(let i, let j): return "-\(j)@\(i)"
        }
    }
}
