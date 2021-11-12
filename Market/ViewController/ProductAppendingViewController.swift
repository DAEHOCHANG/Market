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
    
    weak var calendarViewModel: MarketCalendarsViewModel?
    weak var historyViewModel: HistoryViewModel?
    var appendingDay: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number.text = "1"
    }
    
    // 뒤로가기 버튼
    @IBAction func backButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        guard let day = appendingDay, let viewModel = calendarViewModel else { plusFailFunction(1);return }
        guard let name = name.text, let quantStr = number.text else { plusFailFunction(2);return }
        
        let quantityS = quantStr.components(separatedBy: CharacterSet.letters).joined().trimmingCharacters(in: .whitespaces)
        let unit = quantStr.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespaces)
        guard let quantity = Int(quantityS) else { plusFailFunction(3);return }
        
        let product = MarketProduct(product: Product(productName: name, unit: unit), productQuantity: quantity)
        viewModel.appendProduct(when: day, product: product)
        historyViewModel?.appendProduct(product: product.product)
        
        self.presentingViewController?.dismiss(animated: true)
    }
    func plusFailFunction(_ num: Int) {
        let message = num == 3 ? "수량 단위 형식으로 입력해 주세요\nex) 30kg, 30 kg, 1근, 30개" : "예상하지 못한 에러발생 종료후 다시 시도해보세요"
        
        let failAlert = UIAlertController(title: "입력 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        failAlert.addAction(okAction)
        
        self.present(failAlert, animated: true, completion: nil)
    }
}
