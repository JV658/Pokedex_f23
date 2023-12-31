//
//  CollectionViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-10-18.
//


/**
 Challenge: lazy load all images of all pokemon
 
 - how to pull next set of data (hint: either change the limit or use the "next" paramter from the fetchPokedex API method
 - to lazy load fetch the next subset of data when last cell is being displayed.
 - optimize fetching sequence to fetch multiple images at once
 - add all sprite names to the pokeDetail structure
 - add condition (optional binding) to add all sprites
 */

import UIKit

class PokedexCollectionViewController: UICollectionViewController {
    
    var pokeImages: [UIImage] = []
    var offset = 0
    var inProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        Task {
            do {
                inProgress = true
                // list of pokemone (first 20)
                let pokedex = try await PokeAPI_Helper.fetchPokedex(offset: 0, limit: 50)
                offset = 50;
                // get the images (sprites) for all these pokemon
                for pokemon in pokedex.results {
                    let images = try await PokeAPI_Helper.fetchPokeImages(pokeDetailURL: pokemon.url)
                    for image in images {
                        pokeImages.append(UIImage(data: image)!)
                        collectionView.insertItems(at: [IndexPath(row: pokeImages.count - 1, section: 0)])
                    }
                }
                inProgress = false
//                collectionView.reloadData()
                // append sprites to pokeImage array
            } catch {
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pokeImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeImage", for: indexPath) as! PokeImageCollectionViewCell
    
        // Configure the cell
        cell.pokeImageView.image = pokeImages[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == pokeImages.count
            && !inProgress{
            // run pokeapi helper method that fetch images from a pokedetail url
            Task {
                inProgress = true
                let pokedex = try await PokeAPI_Helper.fetchPokedex(offset: offset)
                offset += 20
                inProgress = false

                for pokemon in pokedex.results {
                    let images = try await PokeAPI_Helper.fetchPokeImages(pokeDetailURL: pokemon.url)
                    for image in images {
                        pokeImages.append(UIImage(data: image)!)
//                        collectionView.insertItems(at: [IndexPath(row: pokeImages.count - 1, section: 0)])
                    }
                }
                collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
