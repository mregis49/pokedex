//
//  MovesCell.swift
//  pokedex
//
//  Created by Regis Family on 3/5/16.
//  Copyright © 2016 Regis Family. All rights reserved.
//

import UIKit

class MovesCell: UITableViewCell {
    
    @IBOutlet weak var moveNameLbl: UILabel!
    @IBOutlet weak var moveDescLbl: UILabel!
    @IBOutlet weak var movePowerLbl: UILabel!
    @IBOutlet weak var moveAccuracyLbl: UILabel!
    
    var move: Move!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(move: Move) {
        moveNameLbl.text = move.name
        moveDescLbl.text = move.description
        movePowerLbl.text = move.power
        moveAccuracyLbl.text = move.accuracy
    }
}
