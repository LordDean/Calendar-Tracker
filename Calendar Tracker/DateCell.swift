//
//  DateCell.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 12/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    func setSelectedStyle() {
        self.backgroundColor = .black
        self.dateLabel.textColor = .white
    }
    
    func setDeselectedStyle() {
        self.backgroundColor = .white
        self.dateLabel.textColor = .black
    }
    
    func setTodayStyle() {
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    func setNotTodayStyle() {
        self.layer.borderWidth = 0
    }
}
