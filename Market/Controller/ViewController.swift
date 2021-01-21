//
//  ViewController.swift
//  Market
//
//  Created by 장대호 on 2021/01/14.
//

import UIKit
import FSCalendar


class ViewController: UIViewController  {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedDate: UILabel!
    var arr: Array<String>? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonFileRead()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        setDate(date: dateFormatter.string(from: calendar.today!))
        selectedDate.text = "Date : \(getDate())"
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.delegate = self
        calendar.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arr = mData[getDate()]
        self.tableView.reloadData()
        self.calendar.reloadData()
    }
    

}



extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    //날짜 선택시 메소드
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        setDate(date: dateFormatter.string(from: date))
        selectedDate.text = "Date : \(getDate())"
        arr = mData[getDate()]
        self.tableView.reloadData()
        
    }
    
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        selectedDate.text = "Date"
        setDate(date: "")
        arr = nil
    }

    //이벤트 띄우는 메서드
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if mData[dateFormatter.string(from: date)] != nil {
            return 1
        }
        return 0
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableview_cell") else {
            fatalError("fdsfsad")
        }
        let tmp = arr ?? []
        if tmp.count > 0{
            let insertString:String = forTableViewString(s:tmp[indexPath.row])
            cell.textLabel?.text = insertString
        }
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.arr?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            mData[getDate()]?.remove(at: indexPath.row)
            if mData[getDate()]?.count == 0 {
                mData.removeValue(forKey: getDate())
            }
            jsonFileWrite()
            self.calendar.reloadData()
            success(true)
        })
        let modifyAction = UIContextualAction(style: .normal, title:  "수정", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let vc = self.storyboard?.instantiateViewController(identifier: "AddStarList") as! AddStarList
            vc.modalPresentationStyle = .fullScreen
            vc.modify = true
            vc.modifyRow = indexPath.row
            vc.inputString = mData[getDate()]?[indexPath.row]
            vc.pm = .modify
            self.present(vc, animated: true, completion: nil)
            
            success(true)
        })
        
        
        return UISwipeActionsConfiguration(actions:[deleteAction,modifyAction])
        
    }
}

