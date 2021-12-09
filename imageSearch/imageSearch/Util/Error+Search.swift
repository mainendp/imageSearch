//
//  Error+Search.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import Foundation


enum SearchError: Error, CaseIterable {
    
    case badRequest
    case unauthorized
    case forbidden
    case tooManyRequest
    case internalServerError
    case badGateway
    case serviceUnavailable
    
    var statusCode: Int {
        switch self {
        case .badRequest:          return 400
        case .unauthorized:        return 401
        case .forbidden:           return 403
        case .tooManyRequest:      return 429
        case .internalServerError: return 500
        case .badGateway:          return 502
        case .serviceUnavailable:  return 503
        }
    }
    
    var errorDescription: String {
        switch self {
        case .badRequest:          return "클라이언트 오류가 발생해 요청을 처리하지 못했습니다."
        case .unauthorized:        return "인증 요청에 실패했습니다."
        case .forbidden:           return "권한 오류가 발생했습니다."
        case .tooManyRequest:      return "요청 한도를 초과했습니다."
        case .internalServerError: return "시스템 오류가 발생했습니다."
        case .badGateway:          return "게이트웨이 오휴가 발생했습니다."
        case .serviceUnavailable:  return "서비스 점검 중 입니다."
        }
    }
}


extension SearchError {
    
    init(with errorCode: Int?) {
        if let errorCode = errorCode {
            let errors = SearchError.allCases.filter { $0.statusCode == errorCode }
            self = errors[0]
        } else {
            self = .badRequest
        }
    }
}
