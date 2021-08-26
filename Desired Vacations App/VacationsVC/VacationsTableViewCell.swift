//
//  VacationsTableViewCell.swift
//  Desired Vacations App
//
//  Created by Synergy on 24.08.21.
//

import UIKit

class VacationsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var vacationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.cornerRadius = 10
        vacationImageView.layer.cornerRadius = cardView.layer.cornerRadius
    }

  

}
