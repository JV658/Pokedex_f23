//
//  PokemonDetailedViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import UIKit
import CoreData

class PokemonDetailedViewController: UIViewController {

    var pokemon: Pokemon!
    var pokeDetails: PokeDetails!
    var container: NSPersistentContainer!
    var name: String!
    var favPokemonObject: Favorites?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        // change button image and tint color
        if favPokemonObject != nil {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            sender.tintColor = .black
            // TODO: remove favorite
            if let favPokemonObject = favPokemonObject {
                container.viewContext.delete(favPokemonObject)
            }
            favPokemonObject = nil
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            sender.tintColor = .yellow
            // add this favorite to pokemon
            let fav = Favorites(context: container.viewContext)
            fav.name = pokemon.name
            fav.url = pokemon.url
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            favPokemonObject = fav
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favPokemonObject = favPokemonObject {
            pokemon = Pokemon(name: favPokemonObject.name!, url: favPokemonObject.url!)
        }

        // Do any additional setup after loading the view.
        self.navigationItem.title = pokemon.name
        
        idLabel.text = ""
        heightLabel.text = ""
        weightLabel.text = ""
        
        container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        // TODO: fetch this pokemon from Core Data
        // if it exists then it is already favorited
        let favoritesFetch = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        let results = try! container.viewContext.fetch(favoritesFetch)
        
        print(results)
        
        
        
        
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
                    let pokeImageData = try await PokeAPI_Helper.fetchPokeImage(urlSring: url)
                    
                    imageView.image = UIImage(data: pokeImageData)
                }
                
                
                
                spinner.stopAnimating()
            } catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         optimize this code block to not run on every single viewWillAppear if favPokemon already exists or not
         */
        let favoritesFetch = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        let results = try! container.viewContext.fetch(favoritesFetch)
                
        favButton.setImage(UIImage(systemName: "star"), for: .normal)
        favButton.tintColor = .black
        for fav in results {
            if(fav.name == pokemon.name){
                // if already fav make star yellow
                favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favButton.tintColor = .yellow
                favPokemonObject = fav
                break;
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
