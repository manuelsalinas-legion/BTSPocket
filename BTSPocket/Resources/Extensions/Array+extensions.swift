//
//  Array+extensions.swift
//  BTSPocket
//
//

import UIKit

func +=<K, V> (left: inout [K: V], right: [K: V]) {
    for (key, value) in right {
        left[key] = value
    }
}
