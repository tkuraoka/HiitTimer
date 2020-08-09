//
//  ViewController.swift
//  HiitTimer
//
//  Created by 倉岡隆志 on 2020/07/29.
//  Copyright © 2020 TakashiKuraoka. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    let pv = UIPickerView()
    var seconds = [
        [5]
    ]
    
    let setPv = UIPickerView()
    var setCount = [
        [1]
    ]
    // 初期値設定のためにイニシャライズ
    let data = setFirstData().userDefault
    
    var onTimeValue = UserDefaults.standard.integer(forKey: "onTime")
    var offTimeValue = UserDefaults.standard.integer(forKey: "offTime")
    var countValue = UserDefaults.standard.integer(forKey: "count")
    
    
    var pickerSec = 0
    var pickerCount = 0
    @IBOutlet weak var onTimeTitle: UIButton!
    @IBOutlet weak var offTimeTitle: UIButton!
    @IBOutlet weak var setTitle: UIButton!
    
    
    @IBAction func onTimeButton(_ sender: Any) {
        actionPicker(0)
    }
    
    @IBAction func offTimeButton(_ sender: Any) {
        actionPicker(1)
    }
    
    @IBAction func setCountButton(_ sender: Any) {
        countPicker()
    }
    
    
    @IBAction func startButton(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for num in stride(from: 10, to: 1205, by: 5) {
            seconds[0].append(num)
        }
        
        for num2 in 2...99 {
            setCount[0].append(num2)
        }
        
        // UserDefaultから値を読み込む
        print(offTimeValue)
        
        
        
        
        // ボタンデザイン OnTime
        onTimeTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        onTimeTitle.titleLabel?.numberOfLines = 2
        onTimeTitle.titleLabel?.textAlignment = .center
        // ボタンデザイン OffTime
        offTimeTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        offTimeTitle.titleLabel?.numberOfLines = 2
        offTimeTitle.titleLabel?.textAlignment = .center
        // ボタンデザイン SetCount
        setTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        setTitle.titleLabel?.numberOfLines = 2
        setTitle.titleLabel?.textAlignment = .center
        
        onTimeTitle.setTitle("運動\n\(onTimeValue)", for: .normal)
        offTimeTitle.setTitle("休憩\n\(offTimeValue)", for: .normal)
        setTitle.setTitle("セット数\n\(countValue)", for: .normal)
        
        
    }
    
    func actionPicker(_ selectButton: Int) {
        let title = "設定時間"
        let message = "\n\n\n\n\n\n\n\n"
        var second = 0
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            second = self.pickerSec
            print("DEBUG_PRINT: OKが押されました　\(second)")
            
            
            if selectButton == 0 {
                self.onTimeValue = self.pickerSec
                self.onTimeTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.onTimeTitle.setTitle("運動\n\(self.onTimeValue)", for: .normal)
                
                // 値の保存
                UserDefaults.standard.set(self.onTimeValue, forKey: "onTime")
                
            } else {
                self.offTimeValue = self.pickerSec
                print(self.onTimeValue)
                self.offTimeTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.offTimeTitle.setTitle("休憩\n\(self.offTimeValue)", for: .normal)
                
                // 値の保存
                UserDefaults.standard.set(self.offTimeValue, forKey: "offTime")
                
            }
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        
        // PickerView
        pv.selectedRow(inComponent: 0)
        pv.frame = CGRect(x: view.bounds.width / 2 - 150, y: 50, width: 200, height: 150)
        pv.dataSource = self
        pv.delegate = self
        alert.view.addSubview(pv)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        

        return
    }
    
    func countPicker() {
        let title = "セット数の設定"
        let message = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            self.countValue = self.pickerCount
            
            self.setTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.setTitle.setTitle("セット数\n\(self.countValue)", for: .normal)
            
            UserDefaults.standard.set(self.countValue, forKey: "count")
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        
        // PickerView
        setPv.selectedRow(inComponent: 0)
        setPv.frame = CGRect(x: view.bounds.width / 2 - 150, y: 50, width: 200, height: 150)
        setPv.dataSource = self
        setPv.delegate = self
        alert.view.addSubview(setPv)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

        return
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pv {
            return seconds.count
        } else {
            return setCount.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pv {
            return seconds[component].count
        } else {
            return setCount[component].count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pv {
            return String(seconds[component][row])
        } else {
            return String(setCount[component][row])
        }

    }
    
    // PickerViewの項目選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("didSelectRowが押されました")
        if pickerView == pv {
            pickerSec = Int(seconds[component][row])
            print("DEBUG_PRINT: \(pickerSec)")
        } else {
            pickerCount = Int(setCount[component][row])
        }
    }
    


}

