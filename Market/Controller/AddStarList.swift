//
//  AddStarList.swift
//  Market
//
//  Created by 장대호 on 2021/01/15.
//

import Foundation
import UIKit

enum PlusModify { case modify, plus}

class AddStarList: UIViewController {
    @IBOutlet weak var plusName: UITextField!
    @IBOutlet weak var weigth: UITextField!
    @IBOutlet weak var weigthUnit: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var numberUnit: UITextField!
    @IBOutlet weak var plusModify: UIButton!
    var modify: Bool = false
    var modifyRow: Int = 0
    var inputString: String? = nil
    var pm: PlusModify = .plus
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let s = inputString {
            let ss = s.split(separator: "/")
            if ss[0] != "_" {plusName.text = String(ss[0])}
            if ss[1] != "_" {weigth.text = String(ss[1])}
            if ss[2] != "_" {weigthUnit.text = String(ss[2])}
            if ss[3] != "_" {number.text = String(ss[3])}
            if ss[4] != "_" {numberUnit.text = String(ss[4])}
            inputString = nil
        }
        if pm == .modify {
            plusModify.setTitle("수정", for: .normal)
            pm = .plus
        } else {
            plusModify.setTitle("추가", for: .normal)
        }
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
        modify = false
    }
    @IBAction func plusButton(_ sender: UIButton) {
        //let s = "\(plusName.text!)/\(weigth.text!)/\(weigthUnit.text!)/\(number.text!)/\(numberUnit.text!)"
        if plusName.text! == "" {
            return
        }
        var ss:String = "\(plusName.text!)/"
        ss += weigth.text! == "" ? "_/" : "\(weigth.text!)/"
        ss += weigthUnit.text! == "" ? "_/" : "\(weigthUnit.text!)/"
        ss += number.text! == "" ? "_/" : "\(number.text!)/"
        ss += numberUnit.text! == "" ? "_/" : "\(numberUnit.text!)/"
        
        guard modify == false else {
            mData[getDate()]?[modifyRow] = ss
            modify = false
            jsonFileWrite()
            
            self.presentingViewController?.dismiss(animated: true)
            return
        }
        
        if mData[getDate()] == nil {
            mData[getDate()] = []
        }
        mData[getDate()]?.append(ss)
        starData.append(ss)
        jsonFileWrite()
        self.presentingViewController?.dismiss(animated: true)
    }
}


