//
//  DateCell.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 12/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    @IBOutlet weak private var dateLabel: UILabel!
    
    private var isToday = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
    }
    
    
    func setSelectedStyle() {
        self.backgroundColor = self.isToday ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : .black
        self.dateLabel.textColor = .white
    }
    
    func setDeselectedStyle() {
        self.backgroundColor = .white
        self.dateLabel.textColor = .black
    }
    
    func setTodayStyle() {
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        self.isToday = true
    }
    
    func setNotTodayStyle() {
        self.layer.borderWidth = 0
        self.isToday = false
    }
    
    func setDate(_ date: Int) {
        if date <= 0 {
            self.isHidden = true
        } else {
            self.isHidden = false
            self.setDeselectedStyle()
            self.dateLabel.text = String(date)
        }
    }
    
}
