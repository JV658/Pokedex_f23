//
//  CacheEntry.swift
//  Pokedex
//
//  Created by Cambrian on 2023-10-11.
//

import Foundation

final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) {
        self.entry = entry
    }
}

enum CacheEntry {
    case inProgress(Task<Data, Error>)
    case ready(Data)
}
