//
//  ViewController.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 11/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

var monthNow: Int {
    return Calendar.current.component(.month, from: Date()) - 1
}
var yearNow: Int {
    return Calendar.current.component(.year, from: Date())
}
var dayNow: Int {
    return Calendar.current.component(.day, from: Date())
}


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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(navButtonPressed))
        navigationItem.leftBarButtonItem?.tag = 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(navButtonPressed))
        navigationItem.rightBarButtonItem?.tag = 2
        
        updateMonth()
    }
    
    @IBAction func todayButtonPressed(_ sender: Any) {
        currentYear = yearNow
        currentMonth = monthNow
        updateMonth()
    }
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        updateMonth(withChange: -1)
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        updateMonth(withChange: 1)
    }
    
    
    // MARK: Custom Methods
    
    func updateMonth(withChange change: Int = 0) {
        currentMonth += change
        if currentMonth < 0 {
            currentMonth = 11
            currentYear -= 1
        } else if currentMonth > 11 {
            currentMonth = 0
            currentYear += 1
        }
        
        // Handle leap years
        if currentMonth + 1 == 2 { numberOfDaysInMonth[1] = currentYear % 4 == 0 ? 29 : 28 }
        
        todayButton.isEnabled = !(currentMonth == monthNow && currentYear == yearNow)
        
        title = monthNames[currentMonth] + " " + String(currentYear)
        firstWeekDayOfMonth = getFirstWeekDay(ofMonth: currentMonth + 1, inYear: currentYear)
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            for cell in selectedCells {
                collectionView.deselectItem(at: cell, animated: false)
            }
        }
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
    
    func isToday(day: Int, month: Int, year: Int) -> Bool {
        return year == yearNow && month == monthNow && day == dayNow
    }
    
    // MARK: Collection View Setup
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[currentMonth] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
        collectionView.deselectItem(at: indexPath, animated: false)
        let cellDay = indexPath.item - firstWeekDayOfMonth + 2
        cell.setDate(cellDay)
        
        if isToday(day: cellDay, month: currentMonth, year: currentYear) {
            cell.setTodayStyle()
        } else {
            cell.setNotTodayStyle()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        cell.setSelectedStyle()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        cell.setDeselectedStyle()
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


extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

