//
//  AddStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

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
    
    @IBAction func swipeBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.modalTransitionStyle = .crossDissolve
        self.presentingViewController?.dismiss(animated: true)
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
        //UIScreen 은 뭐하는놈이길래,.... 
        toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace,exitButton], animated: false)
        number.inputAccessoryView = toolbar
    }
    
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
