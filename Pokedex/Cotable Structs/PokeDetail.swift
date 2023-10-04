//
//  PokeDetail.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import Foundation

struct PokeDetails: Codable {
    let id: Int
    let weight: Int
    let height: Int
    let sprites: Sprites
    
    struct Sprites: Codable {
        let front_default: String?
    }
}
