//
//  AddStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

class ProductAppendingViewController: UIViewController {

    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet var addView: UIView!
    weak var calendarViewModel: MarketCalendarsViewModel?
    weak var historyViewModel: HistoryViewModel?
    var appendingDay: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number.text = "1"
        number.tintColor = .clear
        //setting()
    }
    
    //뒤로가기 버튼
    @IBAction func backButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        defer { self.presentingViewController?.dismiss(animated: true) }
        
        guard let day = appendingDay, let viewModel = calendarViewModel else { return }
        guard let name = name.text, let quantStr = number.text else { return }
        
        let quantityS = quantStr.components(separatedBy: CharacterSet.letters).joined().trimmingCharacters(in: .whitespaces)
        let unit = quantStr.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespaces)
        
        guard let quantity = Int(quantityS) else { return }
        
        let product = MarketProduct(product: tmpProduct(productName: name), productQuantity: quantity,unit: unit)
        viewModel.appendProduct(when: day, product: product)
        historyViewModel?.appendProduct(product: product.product)
    }
    
    //number뷰를 클리갛면 피커뷰 나오게
    /*
    func setting() {
        let picker = UIPickerView()
        picker.delegate = self
        number.inputView = picker
        
        let exitButton = UIBarButtonItem()
        exitButton.title = "선택"
        exitButton.target = self
        exitButton.action = #selector(pickerExit)
        //exitButton.tintColor = .darkGray
        
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemBlue
        toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace,exitButton], animated: false)
        number.inputAccessoryView = toolbar
    }*/
    
    
}



extension ProductAppendingViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    @objc func pickerExit() {
        self.number.text = "\(numbering[selectedRow])"
        selectedRow = 0
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbering.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbering[row])
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

extension UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
