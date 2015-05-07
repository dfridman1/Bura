//
//  helper_functions.swift
//  Bura
//
//  Created by Denys FRIDMAN on 4/4/15.
//  Copyright (c) 2015 Denys FRIDMAN. All rights reserved.
//

import Foundation



func Map<U, V>(f: U -> V, arr: [U]) -> [V] {
    if (arr.isEmpty) { return []; }
    return [f(arr.first!)] + Map(f, Array(dropFirst(arr)));
}



func Filter<T>(predicate: T -> Bool, arr: [T]) -> [T] {
    if (arr.isEmpty) { return []; }
    else if (predicate(arr.first!)) { return [arr.first!] + Filter(predicate, Array(dropFirst(arr))); }
    return Filter(predicate, Array(dropFirst(arr)));
}



func FoldL<U, V>(f: (U, V) -> U, zero: U, arr: [V]) -> U {
    if (arr.isEmpty) { return zero; };
    return FoldL(f, f(zero, arr.first!), Array(dropFirst(arr)));
}



func FoldR<U, V>(f: (U, V) -> V, zero: V, arr: [U]) -> V {
    if (arr.isEmpty) { return zero; }
    return f(arr.first! ,FoldR(f, zero, Array(dropFirst(arr))));
}



func Concat<T>(matrix: [[T]]) -> [T] {
    return FoldL({ a, b in a + b }, [], matrix);
}



func ConcatMap<U, V>(f: U -> [V], arr: [U]) -> [V] {
    return Concat(Map(f, arr));
}



func Insert<T>(arr: [T], x: T) -> [[T]] {
    if (arr.isEmpty) { return [[x]]; }
    return [[x] + arr] + Map({ l in [arr.first!] + l }, Insert(Array(dropFirst(arr)), x));
}



func AllPermutations<T>(arr: [T]) -> [[T]] {
    return FoldR({ x, acc in ConcatMap({ elem in Insert(elem, x) }, acc) }, [[]], arr);
}



func AllSubsets<T>(arr: [T]) -> [[T]] {
    if (arr.isEmpty) { return [[]]; }
    let first: [T] = [arr.first!];
    return Map({ list in first + list }, AllSubsets(Array(dropFirst(arr)))) + AllSubsets(Array(dropFirst(arr)));
}