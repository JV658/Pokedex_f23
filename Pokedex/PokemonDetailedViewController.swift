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
    var isFav: Bool!
    var name: String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        // change button image and tint color
        if isFav {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            sender.tintColor = .black
            // TODO: remove favorite
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            sender.tintColor = .yellow
            // add this favorite to pokemon
            let fav = Favorites(context: container.viewContext)
            fav.id = Int16(idLabel.text!)!
            fav.name = pokemon.name
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if(results.count != 0){
            // if already fav make star yellow
            isFav = true
        } else {
            isFav = false
        }
        
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
