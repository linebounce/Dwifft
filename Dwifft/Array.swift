//
//  Array.swift
//  Dwifft
//
//  Created by Key Hoffman on 11/4/16.
//  Copyright © 2016 jflinter. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    
    /// Returns the sequence of ArrayDiffResults required to transform one array into another.
    public func diff(_ other: [Element]) -> Diff<Element> {
        let table = MemoizedSequenceComparison.buildTable(self, other, self.count, other.count)
        return Array.diffFromIndices(table, self, other, self.count, other.count)
    }
    
    /// Returns the longest common subsequence between two arrays.
    public func LCS(_ other: [Element]) -> [Element] {
        let table = MemoizedSequenceComparison.buildTable(self, other, self.count, other.count)
        return Array.lcsFromIndices(table, self, other, self.count, other.count)
    }
    
    /// Applies a generated diff to an array. The following should always be true:
    /// Given x: [T], y: [T], x.apply(x.diff(y)) == y
    public func apply(_ diff: Diff<Element>) -> Array<Element> {
        var copy = self
        for result in diff.deletions {
            copy.remove(at: result.idx)
        }
        for result in diff.insertions {
            copy.insert(result.value, at: result.idx)
        }
        return copy
    }
    
}

fileprivate extension Array where Element: Equatable {
    /// Walks back through the generated table to generate the diff.
    fileprivate static func diffFromIndices(_ table: [[Int]], _ x: [Element], _ y: [Element], _ i: Int, _ j: Int) -> Diff<Element> {
        if i == 0 && j == 0 {
            return Diff<Element>(results: [])
        } else if i == 0 {
            return diffFromIndices(table, x, y, i, j - 1) + DiffStep.insert(j - 1, y[j - 1])
        } else if j == 0 {
            return diffFromIndices(table, x, y, i - 1, j) + DiffStep.delete(i - 1, x[i - 1])
        } else if table[i][j] == table[i][j - 1] {
            return diffFromIndices(table, x, y, i, j - 1) + DiffStep.insert(j - 1, y[j - 1])
        } else if table[i][j] == table[i - 1][j] {
            return diffFromIndices(table, x, y, i - 1, j) + DiffStep.delete(i - 1, x[i - 1])
        } else {
            return diffFromIndices(table, x, y, i - 1, j - 1)
        }
    }
    
    /// Walks back through the generated table to generate the LCS.
    fileprivate static func lcsFromIndices(_ table: [[Int]], _ x: [Element], _ y: [Element], _ i: Int, _ j: Int) -> [Element] {
        if i == 0 || j == 0 {
            return []
        } else if x[i - 1] == y[j - 1] {
            return lcsFromIndices(table, x, y, i - 1, j - 1) + [x[i - 1]]
        } else if table[i - 1][j] > table[i][j - 1] {
            return lcsFromIndices(table, x, y, i - 1, j)
        } else {
            return lcsFromIndices(table, x, y, i, j - 1)
        }
    }
    
}
