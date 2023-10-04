//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Cambrian on 2023-10-04.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var task = Task {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        pokeImageView.image = UIImage(systemName: "person")
        task.cancel()
    }

}
