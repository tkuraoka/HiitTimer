//
//  TimerViewController.swift
//  HiitTimer
//
//  Created by 倉岡隆志 on 2020/08/01.
//  Copyright © 2020 TakashiKuraoka. All rights reserved.
//

import UIKit
import Lottie

class TimerViewController: UIViewController,CountDownDelegate {

    
    
    let onTime = UserDefaults.standard.string(forKey: "onTime")
    let offTime = UserDefaults.standard.string(forKey: "offTime")
//    let setCount = UserDefaults.standard.string(forKey: "count")
    let setCount = 3
    
    // 現在のセット数
    var count = 0
    // 休憩回数も含むカウント
    var totalCount  = 0
    
    var timer: Timer!
    var countDownTimer = 3
    var isStop = true
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var finishButtonText: UIButton!
    @IBOutlet weak var stopButtonText: UIButton!
    
    @IBAction func finishButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stopButton(_ sender: Any) {
        if isStop {
            countDownView.pauseAnimation()
            isStop = false
            stopButtonText.setTitle("再開", for: .normal)
            

        } else {
            countDownView.resumeAnimation()
            isStop = true
            stopButtonText.setTitle("一時停止", for: .normal)

        }
        
        print("DEBUG_PRINT:現在のステータスは \(isStop)")
        
        
    }
    
    var countDownView:CountDownView = CountDownView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // セット数のデザイン設定
        setLabel.layer.masksToBounds = true
        setLabel.layer.cornerRadius = 15
        setLabel.text = "セット数： \(count) / \(setCount) \n準備"
        setLabel.textColor = UIColor.black
        
        // 運動ラベルのデザイン設定
        onLabel.layer.borderWidth = 2
        onLabel.layer.borderColor = UIColor.systemRed.cgColor
        onLabel.layer.cornerRadius = 10
        onLabel.text = "\(onTime!) 秒"
        
        // 休憩ラベルのデザイン設定
        offLabel.layer.borderWidth = 2
        offLabel.layer.borderColor = UIColor.systemBlue.cgColor
        offLabel.layer.cornerRadius = 10
        offLabel.text = "\(offTime!) 秒"
        
        // 終了ボタンのデザイン設定
        finishButtonText.layer.masksToBounds = true
        finishButtonText.layer.cornerRadius = 10
        
        // ストップボタンのデザイン設定
        stopButtonText.layer.masksToBounds = true
        stopButtonText.layer.cornerRadius = 10
        // タイマーの作動
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
        
        // 円のレイヤー
        countDownView.delegate = self
        countDownView.center = CGPoint(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0)
        view.addSubview(countDownView)
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        countDownView.start(max: 3, timeColor: "jyunbi")
    }
    
    @objc func count(_ timer:Timer) {
        
        if countDownTimer > 0 {
            countDownTimer -= 1
            print(countDownTimer)
        }
        
    }

    
    func didCount(count: Int) {
        print("didCountが呼ばれました")
    }
    
    func didFinish() {
        print("didFinishが呼ばれました")
        print("count \(totalCount)")
        // 最後の休憩はカウントしないので-1
        if totalCount < setCount * 2 - 1 {
            // countが0で割り切れる場合は運動、逆は休憩
            if totalCount % 2 == 0 {
                //even 運動
                countDownView.start(max: 5,timeColor: "undou")
                setLabel.backgroundColor = UIColor.systemRed
                count += 1
                totalCount += 1
                
                self.setLabel.text = "セット数： \(count) / \(setCount) \n運動"
                self.setLabel.textColor = UIColor.white
                
                
            } else {
                // Odd number
                countDownView.start(max: 3.0, timeColor: "kyukei")
                self.setLabel.backgroundColor = UIColor.systemBlue
                self.setLabel.textColor = UIColor.white
                
                totalCount += 1
                self.setLabel.text = "セット数： \(count) / \(setCount) \n休憩"
                
            }
            
        } else {
            // 終了した時の処理
            print("PRINT_DEBUG: countは\(count) setCountは\(setCount)")
            countDownView.reset()
            self.setLabel.text = "終了 \nお疲れさまでした"
            showAnimation()
        }

    }

    
    func showAnimation() {
        let animationView = AnimationView(name: "Animation")
        animationView.frame = CGRect(x: 0,y: 0, width: view.bounds.width / 2, height: view.bounds.height / 2)
        animationView.center = self.view.center
        animationView.loopMode = .repeat(3)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        view.addSubview(animationView)
        animationView.play()
    }

}
