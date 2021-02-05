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
    
    required override init!(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "customCell", bundle: nil)
    }
    
    @objc func doIt(_ gesture: UILongPressGestureRecognizer) {
    }
   
}
