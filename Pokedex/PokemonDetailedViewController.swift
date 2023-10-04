//
//  PokemonDetailedViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import UIKit

class PokemonDetailedViewController: UIViewController {

    var pokemon: Pokemon!
    var pokeDetails: PokeDetails!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = pokemon.name
        
        idLabel.text = ""
        heightLabel.text = ""
        weightLabel.text = ""
        
        Task {
            do{
                pokeDetails = try await PokeAPI_Helper.fetchPokeDetails(urlString: pokemon.url)
                idLabel.text = String(pokeDetails.id)
                heightLabel.text = String(pokeDetails.height)
                weightLabel.text = String(pokeDetails.weight)
                
                var url: String?
                if let imageURL = pokeDetails.sprites.front_default {
                    url = imageURL
                } else if let imageURL = pokeDetails.sprites.front_female {
                    url = imageURL
                }
                
                if let url = url {
                    var pokeImageData = try await PokeAPI_Helper.fetchPokeImage(urlSring: url)
                    
                    imageView.image = UIImage(data: pokeImageData)
                }
                
                
                
                spinner.stopAnimating()
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
