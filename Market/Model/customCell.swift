//
//  customCell.swift
//  Market
//
//  Created by 장대호 on 2021/02/03.
//

import UIKit
import FSCalendar

class customCell: FSCalendarCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "customCell", bundle: nil)
    }
}
