//
//  customCell.swift
//  Market
//
//  Created by 장대호 on 2021/02/03.
//


import UIKit
import FSCalendar

class customCell: FSCalendarCell, UIGestureRecognizerDelegate {
    var date:String = ""
    
    required override init!(frame: CGRect) {
        super.init(frame: frame)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(copyPaste(_:)))
        self.addGestureRecognizer(gesture)
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
    
    @objc func copyPaste(_ gesture: UILongPressGestureRecognizer) {
        var copy = UIAlertController(title: "복사", message: "복사하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        var paste = UIAlertController(title: "붙여넣기", message: "붙여넣기 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
    }

}
