//
//  ShowStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

//checkout test!
class ShowHistoryViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var historyList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyList.delegate = self
        historyList.dataSource = self
        

    }

    @IBAction func swipeBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.modalTransitionStyle = .crossDissolve
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func BackButtoin(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.historyList.reloadData()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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

extension ShowHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") else {
            fatalError("error!")
        }
        cell.textLabel?.text = historyData[indexPath.row].toString()
        return cell
    }
    
    
    //드래그해서 삭제하는 경우임
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            historyData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            writeHistoryData()
            success(true)
        })
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    //history에서 클릭해서 추가할 경우
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if marketData[getDate()] == nil {
            marketData[getDate()] = DataOfDate(date: getDate())
        }
        
        let product = Product(name: historyData[indexPath.row].productName, quantity: 1, isBought: false)
        historyData[indexPath.row].count += 1
        historyData.sort(by: {$0.count > $1.count})
        
        marketData[getDate()]?.append(product: product)
        
        writeMarketData()
        writeHistoryData()
        
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func pickerExit() {
        
    }
}
