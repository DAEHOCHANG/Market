//
//  ShowStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

//checkout test!
class ShowHistoryViewController: UIViewController {
    
    @IBOutlet weak var starList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starList.delegate = self
        starList.dataSource = self
    }
   

    
    @IBAction func BackButtoin(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.starList.reloadData()
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
        let product = Product(name: historyData[indexPath.row].productName, quantity: 1)
        marketData[getDate()]?.append(product: product)
        writeMarketData()
        self.presentingViewController?.dismiss(animated: true)
    }
}
