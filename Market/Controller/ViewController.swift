//
//  ViewController.swift
//  Market
//
//  Created by 장대호 on 2021/01/14.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, UIGestureRecognizerDelegate  {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //데이터 받기
        readMarketData()
        readHistoryData()
        
        //날짜 텍스트 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        setDate(date: dateFormatter.string(from: calendar.today!))
        selectedDate.text = "Date : \(getDate())"
        
        //캘린더 설정
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(customCell.self, forCellReuseIdentifier: "customCell")

        //테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
    }

    //다시 나타날 경우 캘린더, ㅌ테이블 뷰 reload해줘야 할 것
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.calendar.reloadData()
    }

    
}


//callendar
extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    //날짜 선택시 메소드
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        setDate(date: dateFormatter.string(from: date))
        selectedDate.text = "Date : \(getDate())"
        self.tableView.reloadData()
        self.calendar.appearance.todayColor = UIColor.clear
        
        
        if Calendar.current.isDateInWeekend(Date()) {
            self.calendar.appearance.titleTodayColor = UIColor.red
        } else {

            self.calendar.appearance.titleTodayColor = UIColor.black
        }
    }
    
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        selectedDate.text = "Date"
        setDate(date: "")
    }

    //이벤트 띄우는 메서드
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if marketData[dateFormatter.string(from: date)] != nil {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        print("1")
        let cell = calendar.dequeueReusableCell(withIdentifier: "customCell", for: date, at: position) as! customCell
        print("2")
        return cell
    }
    

}


//테이블 뷰
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //테이블뷰에 몇개나 올라갈 것인강!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = marketData[getDate()]?.count {
            return cnt
        }
        return 0
    }
    
    //각 셀에 무엇이 올라갈 것인가
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableview_cell") else {
            fatalError("error")
        }
        guard let list = marketData[getDate()]?.getList() else {
            return cell
        }
        
      
        let insertString:String = list[indexPath.row].productToString()
        cell.textLabel?.text = insertString
        cell.textLabel?.textColor = .black
        if list[indexPath.row].isBought == true {
            cell.backgroundColor = .darkGray
        } else {
            
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    //셀을 드래그 했을 때 액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        //삭제, 데이터에서 삭제해 줘야함
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            marketData[getDate()]?.removeProduct(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if marketData[getDate()]?.count == 0 {
                marketData.removeValue(forKey: getDate())
            }
            
            writeMarketData()
            self.calendar.reloadData()
            success(true)
        })
        
        //수정 버튼
        //=> 구매 완료로 변경
        
        let modifyAction1 = UIContextualAction(style: .normal, title:  "구매완료", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            var toProduct = marketData[getDate()]?.getList()[indexPath.row]
            toProduct?.isBought = true
            marketData[getDate()]?.setProduct(at:indexPath.row, to: toProduct!)
            self.tableView.reloadData()
            writeMarketData()
            success(true)
        })
        
        //구매완료 해제
        let modifyAction2 = UIContextualAction(style: .normal, title:  "구매취소", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            var toProduct = marketData[getDate()]?.getList()[indexPath.row]
            toProduct?.isBought = false
            marketData[getDate()]?.setProduct(at:indexPath.row, to: toProduct!)
            self.tableView.reloadData()
            writeMarketData()
            success(true)
        })
        let check = marketData[getDate()]?.getList()[indexPath.row]
        if check?.isBought == false {
            return UISwipeActionsConfiguration(actions:[deleteAction,modifyAction1])
        } else {
            return UISwipeActionsConfiguration(actions:[deleteAction,modifyAction2])
        }
    }
    

}
