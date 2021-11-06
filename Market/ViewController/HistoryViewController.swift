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
    weak var calendarViewModel:MarketCalendarsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyList.delegate = self
        historyList.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.historyList.reloadData()
    }
    //나중에 바로 닫히는것이아닌 카톡방처럼 움직이는 방식으로 바꿀 것
    @IBAction func swipeBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
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
        let name = modelView.histories[indexPath.row].product.productName
        let unit = modelView.histories[indexPath.row].product.unit
        cell.textLabel?.text = "\(name) (\(unit))"
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
