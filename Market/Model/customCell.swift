//
//  customCell.swift
//  Market
//
//  Created by 장대호 on 2021/02/03.
//

import UIKit
import FSCalendar

class customCell: FSCalendarCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var gestureview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(doIt(_:)))
        gestureview.addGestureRecognizer(gesture)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "customCell", bundle: nil)
    }
    @objc func doIt(_ gesture: UILongPressGestureRecognizer) {
        print("hi")
    }
   
}
