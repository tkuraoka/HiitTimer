//
//  Data.swift
//  HiitTimer
//
//  Created by 倉岡隆志 on 2020/08/01.
//  Copyright © 2020 TakashiKuraoka. All rights reserved.
//

import Foundation

class Data {
    
    func setCount() -> Int {
        return 5
        
    }
    
    
}

// 初期値の設定をする
class setFirstData  {
    
    let userDefault = UserDefaults.standard
    
    init() {
        userDefault.register(defaults: ["onTime" : 30,
                                        "offTime" : 10,
                                        "count" : 3])
        
    }
    
    
}
