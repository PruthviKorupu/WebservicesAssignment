//
//  BreedsCell.swift
//  WebservicesAssignment
//
//  Created by Prathi on 05/02/22.
//

import UIKit

class BreedsCell: UITableViewCell {
    
    @IBOutlet weak var breedTitle: UILabel!
    @IBOutlet weak var subBreedTitles: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView(with dog: Dog) {
        breedTitle.text = dog.name
        subBreedTitles.text = dog.subBreed?.joined(separator: ",") ?? ""
    }
}
