//
//  PokeAPI_Helper.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import Foundation

enum PokeAPI_Errors: Error {
    case CannotConvertStringToURL
    case cannotCreateURLComponent
}

actor PokeAPI_Helper {
    private static let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private static let decoder = JSONDecoder()
    private static let cache: NSCache<NSString, CacheEntryObject> = NSCache()
    
    // NOTE you will need to create the codable structure "Pokemon"
    private static func fetch(urlString: String) async throws -> Data {
        // convert url string into a URL **safely**

        guard
            let url = URL(string: urlString)
        else {throw PokeAPI_Errors.CannotConvertStringToURL}
        
        
        if let cached = cache[url] {
            switch cached {
            case let .inProgress(task):
                return try await task.value
            case let .ready(data):
                return data
            }
        }
        
        print(urlString)

        
        let task = Task {
            // create a datatask to fetch the information from the URL
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        
        cache[url] = .inProgress(task)
        do{
            let data = try await task.value
            cache[url] = .ready(data)
            return data
        } catch {
            cache[url] = nil
            throw error
        }
    }
    
    // modify method to accept offset and limit
    public static func fetchPokedex(offset: Int = 0, limit: Int = 20) async throws -> Pokedex {
        
        
        
        // build url string from offset and limit
        // look into URLComponents
        guard
            var urlComp = URLComponents(string: baseURL)
        else {throw PokeAPI_Errors.cannotCreateURLComponent}
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        queryItems.append(URLQueryItem(name: "limit", value: String(limit)))

        urlComp.queryItems = queryItems
        
        do {
//            let data = try await fetch(urlString: "\(baseURL)?offset=\(offset)&limit=\(limit)")
            print("this is the url generated by urlComp: \(urlComp.string!)")
            let data = try await fetch(urlString: urlComp.string!)
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
    
    public static func fetchPokeImage(urlSring: String) async throws -> Data {
        do {
            let data = try await fetch(urlString: urlSring)
            return data
        } catch {
            throw error
        }
    }
    
    public static func fetchPokeImages(pokeDetailURL: String) async throws -> [Data] {
        let pokeData = try await PokeAPI_Helper.fetchPokeDetails(urlString: pokeDetailURL)
        
        var images: [Data] = []
        
        if let front_default = pokeData.sprites.front_default {
            let img = try await PokeAPI_Helper.fetchPokeImage(urlSring: front_default)
            images.append(img)
        }
        
        if let front_female = pokeData.sprites.front_female {
            let img = try await PokeAPI_Helper.fetchPokeImage(urlSring: front_female)
            images.append(img)
        }
        
        return images
    }
    
    /**
     create a new method to fetch images
     
     accept a urlString and return data
     */
    
}
