//
//  CountDownView.swift
//  HiitTimer
//
//  Created by 倉岡隆志 on 2020/08/02.
//  Copyright © 2020 TakashiKuraoka. All rights reserved.
//

import UIKit

@objc protocol CountDownDelegate {
    func didCount(count:Int)
    func didFinish()
}


class CountDownView: UIView, CAAnimationDelegate {
    
    weak var delegate: CountDownDelegate?
    
    var shapeLayer = CAShapeLayer()
    var label = UILabel()
    var max:Double = 0.0
    var timer: Timer?
    var isDelegate = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        print("DEBUG_PRINT: layoutSubviewsが呼ばれました")
        let lineWidth:CGFloat = 10.0
        //let lineColor = UIColor.black
        
        shapeLayer.isHidden = true
        label.isHidden = true
        shapeLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = lineWidth
        
        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = bounds.size.width
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + 2.0 * CGFloat(M_PI)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        
        label.frame = CGRect(x: 0, y: 0, width: frame.width * 2, height: frame.height * 2)
        label.center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        label.textAlignment = NSTextAlignment.center
        // 文字のガタつきを解消
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .heavy)
        //label.font = UIFont.init(name: "DBLCDTempBlack", size: 50)
        addSubview(label)
    }
    
    func start(max:Double, timeColor: String) {
        print("DEBUG_PRINT: start \(max)")
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(count(_:)), userInfo: nil, repeats: true)
        }
        animation(max)
        self.max = max
        label.text = "\(max)"
        shapeLayer.isHidden = false
        label.isHidden = false
        
        switch timeColor {
            case "jyunbi":
                shapeLayer.strokeColor = UIColor.systemYellow.cgColor
                label.textColor = UIColor.systemYellow
            case "undou":
                shapeLayer.strokeColor = UIColor.systemRed.cgColor
                label.textColor = UIColor.systemRed
            case "kyukei":
                shapeLayer.strokeColor = UIColor.systemBlue.cgColor
                label.textColor = UIColor.systemBlue
        default:
            shapeLayer.strokeColor = UIColor.black.cgColor
            label.textColor = UIColor.blue
        }

    }
    
    @objc func count(_ timer: Timer) {
        print("DEBUG_PRINT: \(timer)")
        if self.max > 0 {
            self.max -= 0.1
            label.text = String(format: "%.1f", max)
        } else if max < 0 {
            if self.timer != nil {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
        
        
    }
    
    func animation(_ max: Double) {
        print("animationが呼ばれました")
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = CFTimeInterval(max)
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.delegate = self
        shapeLayer.add(animation, forKey: "circleAnim")
    }
    

    

    
    func pauseAnimation(){
        print("DEBUG_PRINT: ストップしました。現在のカウント数は\(max)")
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime

        self.timer?.invalidate()
        self.timer = nil
    }
    
    func resumeAnimation() {
        print("DEBUG_PRINT: 再開しました。現在のカウント数は\(max)")
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(count(_:)), userInfo: nil, repeats: true)
    }
    
    
    func reset() {
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "circleAnim")

    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("DEBUG_PRINT: animationDidStopが呼ばれました")
        // 一時停止の場合の処理
        if isDelegate != false {
            isDelegate = false
            return
        }
        delegate?.didFinish()

    }
}
