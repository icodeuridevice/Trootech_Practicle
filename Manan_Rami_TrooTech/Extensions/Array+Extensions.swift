////
////  Array+Extensions.swift
////  Manan_Rami_TrooTech
////
////  Created by Manan  on 26/05/22.
////
//
//import Foundation
//
//public extension Sequence where Element: Hashable {
//
//    /// Return the sequence with all duplicates removed.
//    ///
//    /// i.e. `[ 1, 2, 3, 1, 2 ].uniqued() == [ 1, 2, 3 ]`
//    ///
//    /// - note: Taken from stackoverflow.com/a/46354989/3141234, as
//    ///         per @Alexander's comment.
//    func uniqued() -> [Element] {
//        var seen = Set<Element>()
//        return self.filter { seen.insert($0).inserted }
//    }
//}
//
//extension Sequence {
//
//    /// Return the sequence with all duplicates removed.
//    ///
//    /// Duplicate, in this case, is defined as returning `true` from `comparator`.
//    ///
//    /// - note: Taken from stackoverflow.com/a/46354989/3141234
//    func uniqued(comparator: @escaping (Element, Element) throws -> Bool) rethrows -> [Element] {
//        var buffer: [Element] = []
//
//        for element in self {
//            // If element is already in buffer, skip to the next element
//            if try buffer.contains(where: { try comparator(element, $0) }) {
//                continue
//            }
//
//            buffer.append(element)
//        }
//
//        return buffer
//    }
//}
//
//extension Sequence where Element: Equatable {
//
//    /// Return the sequence with all duplicates removed.
//    ///
//    /// i.e. `[ 1, 2, 3, 1, 2 ].uniqued() == [ 1, 2, 3 ]`
//    ///
//    /// - note: Taken from stackoverflow.com/a/46354989/3141234
//    func uniqued() -> [Element] {
//        return self.uniqued(comparator: ==)
//    }
//}
//
//extension Sequence {
//
//    /// Returns the sequence with duplicate elements removed, performing the comparison using the property at
//    /// the supplied keypath.
//    ///
//    /// i.e.
//    ///
//    /// ```
//    /// [
//    ///   MyStruct(value: "Hello"),
//    ///   MyStruct(value: "Hello"),
//    ///   MyStruct(value: "World")
//    ///  ].uniqued(\.value)
//    /// ```
//    /// would result in
//    ///
//    /// ```
//    /// [
//    ///   MyStruct(value: "Hello"),
//    ///   MyStruct(value: "World")
//    /// ]
//    /// ```
//    ///
//    /// - note: Taken from stackoverflow.com/a/46354989/3141234
//    ///
//    func uniqued<T: Equatable>(_ keyPath: KeyPath<Element, T>) -> [Element] {
//        self.uniqued { $0[keyPath: keyPath] == $1[keyPath: keyPath] }
//    }
//}
//
//
//extension Array where Element: Equatable {
//mutating func removeDuplicates() {
//    var result = [Element]()
//    for value in self {
//        if !result.contains(value) {
//            result.append(value)
//        }
//    }
//    self = result
//}}
//
//
//public extension Array where Element: Hashable {
//    func uniquedX() -> [Element] {
//        var seen = Set<Element>()
//        return filter{ seen.insert($0).inserted }
//    }
//}
//
