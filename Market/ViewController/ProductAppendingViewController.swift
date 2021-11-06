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
        
        let product = MarketProduct(product: tmpProduct(productName: name,unit: unit), productQuantity: quantity)
        viewModel.appendProduct(when: day, product: product)
        historyViewModel?.appendProduct(product: product.product)
    }
    
}
