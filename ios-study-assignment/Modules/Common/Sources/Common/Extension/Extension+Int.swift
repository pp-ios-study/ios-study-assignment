//
//  Extension+Int.swift
//  
//
//  Created by 최승명 on 2023/06/11.
//

import Foundation

extension Int {
    /// 숫자의 형식을 변경
    public func suffixNumber() -> String {
        let num: Double = fabs((self as NSNumber).doubleValue)
        
        if num < 1000 {
            return "\(Int(num))"
        } else if 1000 <= num && num < 10000 {
            let exp: Int = Int(log10(num) / 3.0)
            let roundedNum: Double = round(10 * num / pow(1000.0,Double(exp))) / 10
            return "\(Double(roundedNum))천"
        } else {
            let exp: Int = Int(log10(num) / 3.0)
            let roundedNum: Double = round(num / pow(1000.0,Double(exp))) / 10
            return "\(Double(roundedNum))만"
        }
    }
}
