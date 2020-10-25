//
//  Integer+Extension.swift
//  movie
//
//  Created by Thong Hao Yi on 24/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit

extension Int {
    
    func minutesToHourMinutes() -> String {
        let hour = self/60
        let minutes = (self%60)
        
        if(hour > 0) {
             return "\(hour)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
