//
//  ShowStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

//checkout test!
class HistoryViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var historyList: UITableView!
    var cellNum = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
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
        selectedRow = 0
        super.viewWillAppear(animated)
        self.historyList.reloadData()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
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
    
    
    //history에서 클릭해서 추가할 경우
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
        //UIScreen 은 뭐하는놈이길래,....
        toolbar.frame = CGRect(x: 0, y: picker.fs_top-35, width: UIScreen.main.bounds.width, height: 35)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace,exitButton], animated: false)
        
        self.view.addSubview(toolbar)
        self.view.addSubview(picker)
       // self.presentingViewController?.dismiss(animated: true)
    }

}
