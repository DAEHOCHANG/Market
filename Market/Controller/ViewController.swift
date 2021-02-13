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
    var copiedData:DataOfDate? = nil
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
        //테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
    }

    //다시 나타날 경우 캘린더, ㅌ테이블 뷰 reload해줘야 할 것
    override func viewWillAppear(_ animated: Bool) {
        selectedRow = 0
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.calendar.reloadData()
    }

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
    

  
    

}


//테이블 뷰
extension ViewController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
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
        }
    }

    @objc func pickerExit(sender: UIButton) {
        for tmp in self.view.subviews {
            let s = String(describing: type(of:tmp))
            if s ==  "UIToolbar"  || s ==  "UIPickerView" {
                tmp.removeFromSuperview()
            }
        }
        self.navigationController?.toolbar.isHidden = false
        let cellRow = sender.tag
        guard var unit = marketData[getDate()]?.getList()[cellRow] else {
            selectedRow = 0
            return
        }
        unit.quantity = UInt(numbering[selectedRow])
        marketData[getDate()]?.modify(at: cellRow, product: unit)
        self.tableView.reloadData()
        writeMarketData()
        selectedRow = 0
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
