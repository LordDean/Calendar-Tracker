//
//  ViewController.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 11/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth = monthNow
    var currentYear = yearNow
    var firstWeekDayOfMonth = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMonth()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(navButtonPressed))
        navigationItem.leftBarButtonItem?.tag = 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(navButtonPressed))
        navigationItem.rightBarButtonItem?.tag = 2
    }
    

    func updateMonth(withChange change: Int = 0) {
        currentMonth += change
        if currentMonth < 0 {
            currentMonth = 11
            currentYear -= 1
        } else if currentMonth > 11 {
            currentMonth = 0
            currentYear += 1
        }
        
        // Cater for leap years
        if currentMonth + 1 == 2 {
            numberOfDaysInMonth[1] = currentYear % 4 == 0 ? 29 : 28
        }
        
        todayButton.isEnabled = !(currentMonth == monthNow && currentYear == yearNow)
        
        title = monthNames[currentMonth] + " " + String(currentYear)
        firstWeekDayOfMonth = getFirstWeekDay(ofMonth: currentMonth + 1, inYear: currentYear)
        collectionView.reloadData()
    }
    
    @objc func navButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 1 {
            updateMonth(withChange: -1)
        } else {
            updateMonth(withChange: 1)
        }
    }
    
    func getFirstWeekDay(ofMonth month: Int, inYear year: Int) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "\(year)-\(month)-01")
        return date!.firstDayOfTheMonth.weekday
    }
    
    @IBAction func todayButtonPressed(_ sender: Any) {
        currentYear = yearNow
        currentMonth = monthNow
        updateMonth()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[currentMonth] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
        
        if indexPath.row <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.dateLabel.text = String(calcDate)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}



var monthNow: Int {
    return Calendar.current.component(.month, from: Date()) - 1
}
var yearNow: Int {
    return Calendar.current.component(.year, from: Date())
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

