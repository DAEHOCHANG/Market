//
//  ShowStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit


class ShowStarListViewController: UIViewController {
    
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

extension ShowStarListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "starCell") else {
            fatalError("error!")
        }
        cell.textLabel?.text = forTableViewString(s: starData[indexPath.row]) 
        return cell
    }
    
    
    //드래그해서 삭제하는 경우임
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            starData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            jsonFileWrite()
            success(true)
        })
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //mData[getDate()]?.append((tableView.cellForRow(at: indexPath)?.textLabel?.text!)!)
        if mData[getDate()] == nil {
            mData[getDate()] = []
        }
        mData[getDate()]?.append(starData[indexPath.row])
        jsonFileWrite()
        self.presentingViewController?.dismiss(animated: true)
    }
}
