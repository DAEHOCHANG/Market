//
//  AddStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

let numbering: [Int] = [1,2,3,4,5,6,7,8,9,10]
var selectedRow = 0

class AddProduct: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet var addView: UIView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        number.text = "1"
        number.tintColor = .clear
        setting()
    }
    
  
    
    
    //뒤로가기 버튼
    @IBAction func backButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        if name.text == "" {
            let warning = UIAlertController(title: "에러", message: "품목은 필수로 작성해야 합니다", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            warning.addAction(onAction)
            present(warning, animated: true, completion: nil)
            return
        }
        
        if marketData[getDate()] == nil {
            marketData[getDate()] = DataOfDate(date: getDate())
        }
        marketData[getDate()]?.append(product: Product(name: name.text!, quantity: UInt(number.text!) ?? 1, isBought: false))
        historyData.append(newElement: History(productName: name.text!, count: 1))
        writeMarketData()
        writeHistoryData()
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    
    //number뷰를 클리갛면 피커뷰 나오게
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
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace,exitButton], animated: true)
        number.inputAccessoryView = toolbar
        number.isContextMenuInteractionEnabled = false
        
    }
    
    @objc func pickerExit() {
        self.number.text = "\(numbering[selectedRow])"
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
