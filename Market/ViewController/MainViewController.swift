//
//  ViewController.swift
//  Market
//
//  Created by 장대호 on 2021/01/14.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, UIGestureRecognizerDelegate  {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    let calendarViewModel = MarketCalendarsViewModel()
    let histroyViewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //캘린더 설정
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.titleTodayColor = .blue
        calendar.select(Date())
        //테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        calendarViewModel.dataDidChanged = {
            self.tableView.reloadData()
            self.calendar.reloadData()
        }
    }
    
    func selectedDay() -> Int {
        let component = Calendar.current.dateComponents([.day], from: calendar.selectedDate!)
        return component.day!
    }
    
    //다시 나타날 경우 캘린더, ㅌ테이블 뷰 reload해줘야 할 것
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBSegueAction func historySegueAction(_ coder: NSCoder) -> HistoryViewController? {
        let nvc = HistoryViewController(coder: coder)
        nvc?.day = selectedDay()
        nvc?.historyViewModel = self.histroyViewModel
        nvc?.calendarViewModel = self.calendarViewModel
        return nvc
    }
    
    @IBSegueAction func addProductSegueAction(_ coder: NSCoder) -> ProductAppendingViewController? {
        let nvc = ProductAppendingViewController(coder: coder)
        nvc?.appendingDay = selectedDay()
        nvc?.calendarViewModel = self.calendarViewModel
        nvc?.historyViewModel = self.histroyViewModel
        return nvc
    }
    /*
    @IBAction func dateCopy(_ sender: Any) {
        guard let data = marketData[getDate()] else {
            //경고
            let warning = UIAlertController(title: "에러", message: "복사할 데이터가 없습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            warning.addAction(onAction)
            present(warning, animated: true, completion: nil)
            return
        }
        self.copiedData = data
    }
    @IBAction func datePaste(_ sender: Any) {
        guard let data = self.copiedData else {
            //경고
            let warning = UIAlertController(title: "에러", message: "붙여넣을 데이터가 없습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            warning.addAction(onAction)
            present(warning, animated: true, completion: nil)
            return
        }
        marketData[getDate()] = data
        self.calendar.reloadData()
        self.tableView.reloadData()
        writeMarketData()
        self.copiedData = nil
        
        let list = data.getList()
        for tmp in list {
            historyData.append(newElement: History(productName: tmp.name, count: 1))
        }
        writeHistoryData()
        
        
    }
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        print("hi")
    }
*/
}

//callendar
extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    //날짜 선택시 메소드
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.tableView.reloadData()
        self.calendar.appearance.todayColor = UIColor.clear
        
        if Calendar.current.isDateInWeekend(Date()) {
            self.calendar.appearance.titleTodayColor = UIColor.red
        } else {
            self.calendar.appearance.titleTodayColor = UIColor.black
        }
    }
    
    //이벤트 띄우는 메서드
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let component = Calendar.current.dateComponents([.month,.day], from: date)
        let currentMonth = Calendar.current.dateComponents([.month], from: calendar.currentPage+100000).month!
        if currentMonth != component.month || calendarViewModel[component.day!].isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    //캘린더 월 변경시
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let date = calendar.currentPage + 100000
        let compoents = Calendar.current.dateComponents([.year,.month],from: date)
        self.calendarViewModel.changeCalendar(year: String(compoents.year!), month: String(compoents.month!))
    }
}


//테이블 뷰
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    //테이블뷰에 몇개나 올라갈 것인강!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let date = self.calendar.selectedDate else {return 0}
        let components = Calendar.current.dateComponents([.year,.month,.day],from: date)
        guard let day = components.day else {return 0}
        return calendarViewModel[day].count
    }
    
    //각 셀에 무엇이 올라갈 것인가
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") else {
            return UITableViewCell();
        }
        guard let date = self.calendar.selectedDate else {return cell}
        let components = Calendar.current.dateComponents([.year,.month,.day],from: date)
        guard let day = components.day else {return cell}
        let name = calendarViewModel[day][indexPath.row].product.productName
        let quant = calendarViewModel[day][indexPath.row].productQuantity
        let unit = calendarViewModel[day][indexPath.row].product.unit
        cell.textLabel?.text = "\(name) \(quant)\(unit)"
        cell.textLabel?.textColor = .black
        return cell
    }
    
    //셀을 드래그 했을 때 액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        //삭제, 데이터에서 삭제해 줘야함
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let day = self.selectedDay()
            let deletProduct = self.calendarViewModel[day][indexPath.row]
            self.calendarViewModel.deleteProduct(when: day, product: deletProduct)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            success(true)
        })
        
        //수정 버튼
        //=> 구매 완료로 변경
        /*
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
        let changeQuantity = UIContextualAction(style: .normal, title:  "수량변경", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.navigationController?.toolbar.isHidden = true
            let picker = UIPickerView()
            picker.delegate = self
            picker.frame = CGRect(x: 0, y: self.view.fs_bottom-225, width: UIScreen.main.bounds.width, height: 225)
            
            picker.backgroundColor = .systemGray4
            
            let exitButton = UIBarButtonItem()
            exitButton.title = "선택"
            exitButton.target = self
            exitButton.action = #selector(self.pickerExit(sender:))
            exitButton.tag = indexPath.row
            //exitButton.tintColor = .darkGray
            
            
            let toolbar = UIToolbar()
            toolbar.tintColor = .systemBlue
            //UIScreen 은 뭐하는놈이길래,....
            toolbar.frame = CGRect(x: 0, y: picker.fs_top-35, width: UIScreen.main.bounds.width, height: 35)
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexSpace,exitButton], animated: false)
            
            self.view.addSubview(toolbar)
            self.view.addSubview(picker)
            success(true)
        })
        changeQuantity.backgroundColor = .systemBlue
        
        let check = marketData[getDate()]?.getList()[indexPath.row]
        if check?.isBought == false {
            return UISwipeActionsConfiguration(actions:[deleteAction,modifyAction1,changeQuantity])
        } else {
            return UISwipeActionsConfiguration(actions:[deleteAction,modifyAction2,changeQuantity])
        }*/
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }

   
}
