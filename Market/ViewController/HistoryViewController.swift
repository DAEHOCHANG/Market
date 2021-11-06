//
//  ShowStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

//checkout test!
class HistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var historyList: UITableView!
    weak var historyViewModel:HistoryViewModel?
    var cellNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyList.delegate = self
        historyList.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRow = 0
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.historyList.reloadData()
    }
    //나중에 바로 닫히는것이아닌 카톡방처럼 움직이는 방식으로 바꿀 것
    @IBAction func swipeBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HistoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    @objc func pickerExit() {
        if marketData[getDate()] == nil {
            marketData[getDate()] = DataOfDate(date: getDate())
        }
        
        let product = Product(name: historyData[cellNum].productName, quantity: UInt(numbering[selectedRow]), isBought: false)
        print(product)
        historyData[cellNum].count += 1
        historyData.sort(by: {$0.count > $1.count})
        
        marketData[getDate()]?.append(product: product)
        
        writeMarketData()
        writeHistoryData()
        selectedRow = 0
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true)
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modelView = self.historyViewModel else {
            return 0
        }
        return modelView.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") else {
            return UITableViewCell()
        }
        guard let modelView = self.historyViewModel else {
            return UITableViewCell()
        }
        cell.textLabel?.text = modelView.histories[indexPath.row].product.productName
        return cell
    }
    
    
    //드래그해서 삭제하는 경우임
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let viewModel = self.historyViewModel else {return}
            let product = viewModel.histories[indexPath.row].product
            
            viewModel.deleteProduct(product: product)
            tableView.deleteRows(at: [indexPath], with: .fade)
            success(true)
        })
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    
    
    
    //history에서 클릭해서 추가할 경우
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellNum = indexPath.row
        let picker = UIPickerView()
        picker.delegate = self
        picker.frame = CGRect(x: 0, y: self.view.fs_bottom-225, width: UIScreen.main.bounds.width, height: 225)
        
        picker.backgroundColor = .systemGray4
        
        let exitButton = UIBarButtonItem()
        exitButton.title = "선택"
        exitButton.target = self
        exitButton.action = #selector(pickerExit)
        //exitButton.tintColor = .darkGray
        
        
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemBlue
        toolbar.frame = CGRect(x: 0, y: picker.fs_top-35, width: UIScreen.main.bounds.width, height: 35)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace,exitButton], animated: false)
        
        self.view.addSubview(toolbar)
        self.view.addSubview(picker)
    }*/

}
