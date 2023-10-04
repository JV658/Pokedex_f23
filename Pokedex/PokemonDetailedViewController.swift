//
//  PokemonDetailedViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import UIKit

class PokemonDetailedViewController: UIViewController {

    var pokemon: Pokemon!
    var pokeDetails: PokeDetails?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = pokemon.name
        
        Task {
            do{
                pokeDetails = try await PokeAPI_Helper.fetchPokeDetails(urlString: pokemon.url)
                print(pokeDetails?.id)
                print(pokeDetails?.height)
                print(pokeDetails?.weight)
                print(pokeDetails?.sprites.front_default)
            } catch {
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
