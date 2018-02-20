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
    static var selectedColour = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var chosenColour: UIColor?
    
    enum CellState {
        case normal, selected, disabled
    }
    
    var cellState: CellState = .normal {
        didSet {
            switch cellState {
            case .disabled:
                self.isUserInteractionEnabled = false
                self.dateLabel.textColor = .gray
                self.backgroundColor = .clear
                self.layer.borderWidth = 0
            case .normal:
                self.isUserInteractionEnabled = true
                self.layer.borderWidth = 0
                if let colour = chosenColour {
                    self.backgroundColor = colour
                    self.dateLabel.textColor = .white
                } else {
                    self.dateLabel.textColor = .black
                    self.backgroundColor = .clear
                }
            case .selected:
                self.isUserInteractionEnabled = true
                self.dateLabel.textColor = .white
                self.backgroundColor = DateCell.selectedColour
                self.layer.borderWidth = 0
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
    }
    
    func setDate(_ date: Int) {
        if date <= 0 {
            self.isHidden = true
        } else {
            self.isHidden = false
            self.cellState = .normal
            self.dateLabel.text = String(date)
        }
    }
    
}
