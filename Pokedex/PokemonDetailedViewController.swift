//
//  PokemonDetailedViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import UIKit

class PokemonDetailedViewController: UIViewController {

    var pokemon: Pokemon!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = pokemon.name
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
