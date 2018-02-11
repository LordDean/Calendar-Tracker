//
//  ViewController.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 11/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonth = Calendar.current.component(.month, from: Date()) - 1
    var currentYear = Calendar.current.component(.year, from: Date())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMonth()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(navButtonPressed))
        navigationItem.leftBarButtonItem?.tag = 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(navButtonPressed))
        navigationItem.rightBarButtonItem?.tag = 2
    }

    @objc func navButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 1 {
            updateMonth(-1)
        } else {
            updateMonth(1)
        }
        
    }
    
    func updateMonth(_ change: Int = 0) {
        currentMonth += change
        if currentMonth < 0 {
            currentMonth = 11
            currentYear -= 1
        } else if currentMonth > 11 {
            currentMonth = 0
            currentYear += 1
        }
        
        title = monthNames[currentMonth] + " " + String(currentYear)
    }
}

