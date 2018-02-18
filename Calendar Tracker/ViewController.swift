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
    @IBOutlet weak var presentButton: AttendanceButton!
    @IBOutlet weak var halfDayButton: AttendanceButton!
    @IBOutlet weak var absentButton: AttendanceButton!
    
    
    let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth = monthNow
    var currentYear = yearNow
    var firstWeekDayOfMonth = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(navButtonPressed))
        navigationItem.leftBarButtonItem?.tag = 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "❯", style: .plain, target: self, action: #selector(navButtonPressed))
        navigationItem.rightBarButtonItem?.tag = 2
        
        presentButton.colour = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        halfDayButton.colour = #colorLiteral(red: 0.874509871, green: 0.6112361279, blue: 0.1058823615, alpha: 1)
        absentButton.colour = #colorLiteral(red: 0.7333333492, green: 0.03529411927, blue: 0.05882353336, alpha: 1)
        
        makeButtonsSelectable(false)
        
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
    
    @IBAction func presentButtonPressed(_ sender: AttendanceButton) {
        sender.makeSelectable(isChosen: true)
    }
    
    @IBAction func halfDayButtonPressed(_ sender: AttendanceButton) {
        sender.makeSelectable(isChosen: true)
    }
    
    @IBAction func absentButtonPressed(_ sender: AttendanceButton) {
        sender.makeSelectable(isChosen: true)
    }
    
    @objc func navButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 1 {
            updateMonth(withChange: -1)
        } else {
            updateMonth(withChange: 1)
        }
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
        collectionView.reloadData()
        makeButtonsSelectable(false)
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
    
    func makeButtonsSelectable(_ selectable: Bool) {
        if selectable {
            presentButton.makeSelectable()
            halfDayButton.makeSelectable()
            absentButton.makeSelectable()
        } else {
            presentButton.makeUnselectable()
            halfDayButton.makeUnselectable()
            absentButton.makeUnselectable()
        }
        
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
        makeButtonsSelectable(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        cell.setDeselectedStyle()
        makeButtonsSelectable(false)
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

