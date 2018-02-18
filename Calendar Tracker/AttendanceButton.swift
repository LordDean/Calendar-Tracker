//
//  AttendanceButton.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 18/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

class AttendanceButton: UIButton {
    
    var colour = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private let disabledColour = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
    }
    

    func makeSelectable(isChosen: Bool = false) {
        self.isEnabled = true
        if isChosen {
            self.layer.borderWidth = 0
            self.backgroundColor = colour
            self.setTitleColor(.white, for: .normal)
        } else {
            self.layer.borderWidth = 2
            self.layer.borderColor = colour.cgColor
            self.setTitleColor(colour, for: .normal)
            self.backgroundColor = .white
        }
    }
    
    func makeUnselectable() {
        self.isEnabled = false
        self.layer.borderWidth = 2
        self.layer.borderColor = disabledColour.cgColor
        self.setTitleColor(disabledColour, for: .disabled)
        self.backgroundColor = .white
    }
    
}
