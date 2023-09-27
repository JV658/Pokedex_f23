//
//  Pokedex.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import Foundation

struct Pokedex: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
    
}

struct Pokemon: Codable{
    let name: String
    let url: String
}
