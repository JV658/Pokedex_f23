//
//  PokeAPI_Helper.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import Foundation

enum PokeAPI_Errors: Error {
    case CannotConvertStringToURL
}

class PokeAPI_Helper {
    private static let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private static let decoder = JSONDecoder()
    
    // NOTE you will need to create the codable structure "Pokemon"
    private static func fetch(urlString: String) async throws -> Data {
        // convert url string into a URL **safely**
        guard
            let url = URL(string: urlString)
        else {throw PokeAPI_Errors.CannotConvertStringToURL}
        
        do{
            // create a datatask to fetch the information from the URL
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    public static func fetchPokedex() async throws -> Pokedex {
        do {
            let data = try await fetch(urlString: baseURL)
            let pokedex = try decoder.decode(Pokedex.self, from: data)
            return pokedex
        } catch {
            throw error
        }
    }
    
    public static func fetchPokeDetails(urlString: String) async throws -> PokeDetails {
        do {
            let data = try await fetch(urlString: urlString)
            let pokedetails = try decoder.decode(PokeDetails.self, from: data)
            return pokedetails
        } catch {
            throw error
        }
    }
    
    /**
     create a new method to fetch images
     
     accept a urlString and return data
     */
    
}
