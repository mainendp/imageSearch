//
//  String+Util.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import Foundation


extension String {
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let convertedDate = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let convertedDate = convertedDate {
            return dateFormatter.string(from: convertedDate)
        }
        
        return "작성 시간 정보가 없습니다."
    }
}
