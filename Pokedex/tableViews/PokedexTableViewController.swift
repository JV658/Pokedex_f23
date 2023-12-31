//
//  PokedexTableViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-09-27.
//

import UIKit

class PokedexTableViewController: UITableViewController {

    var pokeList = [Pokemon]()
    var currentOffset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
                
        // fetch pokedex and populate pokeList
        Task{
            do{
                let pokedex = try await PokeAPI_Helper.fetchPokedex()
                pokeList = pokedex.results
                currentOffset += 20
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonTableViewCell

        // Configure the cell...
        let pokemon = pokeList[indexPath.row]
//        cell.textLabel!.text = pokemon.name
        cell.nameLabel.text = pokemon.name
        
        
        /**
         create a task to fetch poke details
        create a task to fetch poke image
         set pokeimage as pokeImageView.image
         */
        
        let cellTask = Task {
            do{
                let pokeDetails = try await PokeAPI_Helper.fetchPokeDetails(urlString: pokemon.url)
                let pokeImageData = try await PokeAPI_Helper.fetchPokeImage(urlSring: pokeDetails.sprites.front_default!)
                
                cell.pokeImageView.image = UIImage(data: pokeImageData)
            } catch {
                print(error)
            }
        }
        
        cell.task = cellTask
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == pokeList.count - 10 {
            // fetch more pokemone
            print("fetch more pokemon")
            Task {
                do {
                    let pokedex = try await PokeAPI_Helper.fetchPokedex(offset: currentOffset)
                    pokeList.append(contentsOf: pokedex.results)
                    currentOffset += 20
                    tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dst = segue.destination as! PokemonDetailedViewController
        // get indexpath of cell that was selected
        let index = tableView.indexPathForSelectedRow!.row
        // pass the name and url to the dst
        dst.pokemon = pokeList[index]
    }

}
