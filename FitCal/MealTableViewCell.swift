//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Mason Wesolek on 3/8/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var completeToggle: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
