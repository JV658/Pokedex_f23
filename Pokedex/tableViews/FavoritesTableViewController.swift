//
//  FavoritesTableViewController.swift
//  Pokedex
//
//  Created by Cambrian on 2023-11-01.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController, UISearchBarDelegate {

    var container: NSPersistentContainer!
    var favoriteList: [Favorites] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favFetch = NSFetchRequest<Favorites>(entityName: "Favorites")
        favoriteList = try! container.viewContext.fetch(favFetch)
        print("non-predicate resutls: \(favoriteList)")
        tableView.reloadData()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = favoriteList[indexPath.row].name

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // create fetch request
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        // if string is not empty add predicate to the fetch request
        if !searchText.isEmpty {
            // create predicate. name contains search text
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
            
            fetchRequest.predicate = predicate
        }
            
        // fetch information based on the predicate
        do {
            favoriteList = try container.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        
        // reload the data in the table view
        tableView.reloadData()
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
        let dst = segue.destination as! PokemonDetailedViewController
         // get indexpath of cell that was selected
         let index = tableView.indexPathForSelectedRow!.row
         // pass the name and url to the dst
         dst.favPokemonObject = favoriteList[index]
    }

}
